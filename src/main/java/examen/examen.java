package examen;

import java.sql.*;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class examen {
	@RequestMapping(value = "gsqlCatalogoProducto", method = RequestMethod.POST)
	@ResponseBody
    public String gsqlCatalogoProducto(@RequestParam("txtJson") String txtJson, HttpServletRequest request){
		JSONObject jsnProd= new JSONObject(txtJson);
		JSONObject jsnRslt= new JSONObject();
		jsnRslt.put("txtMnsj", "Error");
		
		Connection conn = conexionExamen();
		
		try{
			ResultSet rsIde = conn.prepareStatement("SELECT nextval('ecomsys.sq_tmpcatalogoproducto') ideProd").executeQuery();
			rsIde.next();

            CallableStatement stmt = conn.prepareCall("{CALL ecomsys.instProducto(?, ?, ?, ?, ?, ?)}");
            stmt.setInt(1, rsIde.getInt("ideProd"));
            stmt.setString(2, jsnProd.getString("nomProd"));
            stmt.setString(3, jsnProd.getString("fecRegi"));
            stmt.registerOutParameter(4, Types.OTHER);
            stmt.registerOutParameter(5, Types.VARCHAR);
            stmt.registerOutParameter(6, Types.VARCHAR);
            stmt.execute();
            
			conn.commit();
			
			jsnRslt.put("codProd", stmt.getString(5));
			jsnRslt.put("txtMnsj", stmt.getString(6));

            ResultSet rs = (ResultSet) stmt.getObject(4);
            JSONArray aryData = new JSONArray();
            while (rs.next()) {
                JSONObject jsnItem = new JSONObject();
                jsnItem.put("ideProd", rs.getInt("ideprod"));
                jsnItem.put("codProd", rs.getString("codprod"));
                jsnItem.put("nomProd", rs.getString("nomprod"));
                jsnItem.put("fecRegi", rs.getString("fecregi"));
                aryData.put(jsnItem);
            }
            
            jsnRslt.put("aryData", aryData);
			
		}catch(Exception e){
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}finally {			
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}			
		}
		return jsnRslt.toString();	
	}

    public Connection conexionExamen() {   	 
    	Connection con = null;
    	
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/bpm_239949780?stringtype=unspecified", "postgres", "admin");
            con.setAutoCommit(false);
        } catch (ClassNotFoundException cnfe) {
            System.out.println("Error de conexión: "+cnfe.getMessage());
        } catch (SQLException sqle) {
            System.out.println("Error : "+sqle.getMessage());
        }
        return con;
    }
}
