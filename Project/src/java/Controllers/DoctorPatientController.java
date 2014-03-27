/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Controllers;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import models.Doctor;
import models.Patient;

/**
 *
 * @author william
 */
public class DoctorPatientController {
    
    public static void create(Connection con, String doctor_id, String patient_id, boolean permission) throws SQLException {
        PreparedStatement ps = con.prepareStatement("INSERT INTO Doctor_Patient values(?,?,?)");
        ps.setString(1, patient_id);
        ps.setString(2, doctor_id);
        ps.setInt(3, permission ? 1 : 0);
        ps.execute();
        ps.close();
    }
    
    public static void delete(Connection con, String doctor_id, String patient_id) throws SQLException {
        PreparedStatement ps = con.prepareStatement("DELETE FROM Doctor_Patient WHERE doctor_user_id = ? AND patient_user_id = ?");
        ps.setString(1, doctor_id);
        ps.setString(2, patient_id);
        ps.execute();
        ps.close();
    }
    
    public static void changeDoctors(Connection con, String doctor_id_old, String doctor_id_new, String patient_id) throws SQLException {
        if (doctor_id_old != null) {
            delete(con, doctor_id_old, patient_id);
        }
        if (!doctor_id_new.equals("none")) {
            create(con, doctor_id_new, patient_id, false);
        }
    }
    
    public static String getDoctorIDOfPatient(Connection con, String patient_id) throws SQLException {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM Doctor,Doctor_Patient WHERE Doctor.user_id=Doctor_Patient.doctor_user_id AND Doctor_Patient.patient_user_id = ?");
        ps.setString(1, patient_id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getString("Doctor.user_id");
        } else {
            return null;
        }
    }
    
    public static ArrayList<Patient> queryByDoctor(Connection con, String doctor_id) throws ClassNotFoundException, SQLException {
        PreparedStatement pstmt = null;
        ArrayList<Patient> ret;

        try {
            //Build SQL Query
            String query = "SELECT * FROM Doctor_Patient, Patient, User "
                    + "WHERE Doctor_Patient.doctor_user_id = ? "
                    + "AND Doctor_Patient.patient_user_id = Patient.user_id AND User.user_id = Patient.user_id";

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, doctor_id);

            ResultSet resultSet;
            resultSet = pstmt.executeQuery();

            ret = new ArrayList<Patient>();
            while (resultSet.next()) {
                ret.add(new Patient(resultSet));
            }
            return ret;
        } finally {
            if (pstmt != null) {
                pstmt.close();
            }
        }
    }
}
