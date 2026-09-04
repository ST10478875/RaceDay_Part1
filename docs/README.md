# RaceDay - Event Management Platform

RaceDay is a full-stack web application designed for managing South African road running, walking, and cycling events.

---

## Project Structure (Part 1 - Planning)

All core architecture and planning documentation can be found inside the `/docs` folder:

- `docs/RaceDay_Database_Script.sql` - Complete SQL Server script with relational schema, FK constraints, and seed data.
- `docs/PROG PART 1.pdf` - Complete documentation and planning specification.

---

## System Roles & Features

* **Organiser**: Creates and manages events, sets up age/distance categories, views participant entries, and logs official finish times/positions.
* **Participant**: Registers an account, explores upcoming events, enrols into specific race categories, and views personal race results.

---

## CI/CD Build Status

![Build Status](docs/build-status.png)

---![Uploading image.png…]()


## Database Execution Setup (SSMS)

1. Open **SQL Server Management Studio (SSMS)**.
2. Open `docs/RaceDay_Database_Script.sql`.
3. Press **F5** to execute. The script will initialize `RaceDayDb`, apply table schemas with check constraints, and seed test data.

---

## Technical Walkthrough Demonstration

[Watch Part 1 Video Walkthrough on YouTube](https://youtu.be/Z6tKdqic7qo)
