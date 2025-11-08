package com.studysync.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "study_sessions")
public class StudySession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String titre; // title

    @Column(nullable = false)
    private LocalDateTime heureDebut; // startTime

    @Column(nullable = false)
    private LocalDateTime heureFin; // endTime

    @Column(length = 2000)
    private String description;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id")
    private StudyGroup groupe;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "organisateur_id")
    private Student organisateur;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "session_participants",
            joinColumns = @JoinColumn(name = "session_id"),
            inverseJoinColumns = @JoinColumn(name = "student_id")
    )
    private Set<Student> participants = new HashSet<>();

    public Long getId() { return id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public LocalDateTime getHeureDebut() { return heureDebut; }
    public void setHeureDebut(LocalDateTime heureDebut) { this.heureDebut = heureDebut; }

    public LocalDateTime getHeureFin() { return heureFin; }
    public void setHeureFin(LocalDateTime heureFin) { this.heureFin = heureFin; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public StudyGroup getGroupe() { return groupe; }
    public void setGroupe(StudyGroup groupe) { this.groupe = groupe; }

    public Student getOrganisateur() { return organisateur; }
    public void setOrganisateur(Student organisateur) { this.organisateur = organisateur; }

    public Set<Student> getParticipants() { return participants; }
    public void setParticipants(Set<Student> participants) { this.participants = participants; }
}


