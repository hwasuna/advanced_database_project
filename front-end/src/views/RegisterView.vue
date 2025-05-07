<template>
    <div class="register-container">
      
        <!-- Rectangle de connexion -->
        <div class="wrapper">
          <form id="register-form" @submit.prevent="createAccount">
            <h1>Create Your Account</h1>
            <p>Fill in the details to register</p>
            <div class="input-box">
              <input type="text" v-model="firstname" placeholder="Your first name" required />
            </div>
            <div class="input-box">
              <input type="text" v-model="lastname" placeholder="Your last Name" required />
            </div>
            <div class="input-box">
              <input type="text" v-model="username" placeholder="Create a username" required />
            </div>
            <div class="input-box">
              <input type="email" v-model="email" placeholder="Your email address" required />
            </div>
            <div class="input-box">
              <input
                :type="showPassword ? 'text' : 'password'"  
                v-model="password"
                placeholder="Create a password"
                required
              />
              <i
                class="fa-solid"
                :class="showPassword ? 'fa-eye-slash' : 'fa-eye'" 
                @click="togglePasswordVisibility"
              ></i>
          </div>
          <div class="input-box">
            <input
              :type="showConfirmPassword ? 'text' : 'password'"  
              v-model="confirm_password"
              placeholder="Confirm your password"
              required
            />
            <i
              class="fa-solid"
              :class="showConfirmPassword ? 'fa-eye-slash' : 'fa-eye'" 
              @click="toggleConfirmPasswordVisibility"
            ></i>
          </div>
            <button  :disabled="!isFormValid" type="submit" class="action-btn">Register</button>
            <p class="login-link">
              Already have an account? <router-link to="/login">Log in</router-link>
            </p>
          </form>
        </div>
      </div>
    </template>
      
      <script>
      import axios from "axios";
      export default {
        name: "RegisterFormComponent",
        data() {
          return {
            firstname: "",
            lastname: "",
            username: "",
            email: "",
            password: "",
            confirmPassword: "",
            showPassword: false, 
            showConfirmPassword: false, 
          };
        }, 
        computed: {
          isFormValid() {
            return (
              this.username &&
              this.firstname &&
              this.lastname &&
              this.email &&
              this.password
            );
          },
        },
        methods: {
          togglePasswordVisibility() {
            this.showPassword = !this.showPassword; // Bascule l'état de l'affichage du mot de passe
          },  
          toggleConfirmPasswordVisibility() {
            this.showConfirmPassword = !this.showConfirmPassword;
          },  
          async createAccount() {
            if (this.password !== this.confirm_password) {
              alert("Passwords do not match!");
              return;
            } else {
              try {
                console.log("Sending data to server:", {
                  username: this.username,
                  firstname: this.firstname,
                  lastname: this.lastname,
                  email: this.email,
                  password: this.password,
                });
  
                const response = await axios.post("http://localhost:8081/register", {
                  username: this.username,
                  firstname: this.firstname,
                  lastname: this.lastname,
                  email: this.email,
                  password: this.password,
                });
  
                console.log("Server response:", response.data); // Log de la réponse du serveur
  
                if (response.data.success) {
                  alert("Account created successfully!");
                  // Reset the form
                  this.username = "";
                  this.firstname = "";
                  this.lastname = "";
                  this.email = "";
                  this.password = "";
                  this.$router.push('/login');
                } else {
                  alert(response.data.message || "Failed to create account.");
                }
              } catch (err) {
                console.error("Error during account creation:", err.response?.data || err.message); // Log de l'erreur
                alert("Error during account creation.");
              }
            }
          },
        },
      };
  </script>
      
      <style scoped>
  /* Global container */
  .register-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh; /* Full viewport height */
    position: relative;
    overflow: hidden;
  }
  
  
  /* Wrapper */
  .wrapper {
    background: rgba(255, 255, 255, 0.9); /* Semi-transparent white background */
    border-radius: 15px;
    padding: 30px;
    width: 100%;
    max-width: 400px;
    text-align: center;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
    animation: fadeIn 1.5s ease-in-out; /* Fade-in animation */
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 1; /* Puts wrapper above the video */
    margin-top: 8%;
  }
  
  /* Fade-in animation */
  @keyframes fadeIn {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  /* Title */
  h1 {
    font-size: 24px;
    font-weight: bold;
    color: #333;
    margin-bottom: 10px;
  }
  
  p {
    font-size: 14px;
    color: #333;
    margin-bottom: 20px;
  }
  
  /* Form styling */
  form {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 100%;
  }
  
  /* Input fields */
  .input-box {
    width: 100%;
    position: relative;
    margin-bottom: 20px;
  }
  
  .input-box input {
    width: 95%;
    padding: 10px 10px;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-size: 14px;
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
  }
  
  .input-box input:focus {
    border-color: #910D00;
    box-shadow: 0 0 8px rgba(201, 36, 10, 0.6);
    outline: none;
  }
  .input-box i {
    position: absolute;
    right: 15px; /* Move icon to the far right */
    top: 50%;
    transform: translateY(-50%);
    font-size: 18px;
    color: #757575;
    cursor: pointer; /* Permet de cliquer sur l'icône */
  }
  
  /* Button styling */
  .action-btn {
    width: 100%;
    padding: 12px;
    background: #910D00;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .action-btn:hover {
    transform: scale(1.05);
    box-shadow: 0 6px 15px rgba(194, 37, 16, 0.4);
  }
  
  .action-btn:active {
    transform: scale(0.95);
  }
  
  /* Login link */
  .login-link {
    margin-top: 15px;
    font-size: 14px;
    color: #333;
  
  }
  
  .login-link a {
    color: #910D00;
    text-decoration: none;
    font-weight: bold;
    transition: color 0.3s ease, text-shadow 0.3s ease;
  }
  
  .login-link a:hover {
    text-decoration: underline;
    text-shadow: 0 0 5px rgba(212, 23, 16, 0.5);
  }
  </style>
  