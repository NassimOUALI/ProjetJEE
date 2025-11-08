package com.studysync.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "posts")
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 4000, nullable = false)
    private String contenu; // content

    @Column(nullable = false)
    private LocalDateTime datePublication = LocalDateTime.now();

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "auteur_id")
    private Student auteur;

    @Column(nullable = false)
    private String type; // e.g., Comment, Resource

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id")
    private StudySession session; // optional

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id")
    private StudyGroup groupe; // optional

    public Long getId() { return id; }

    public String getContenu() { return contenu; }
    public void setContenu(String contenu) { this.contenu = contenu; }

    public LocalDateTime getDatePublication() { return datePublication; }
    public void setDatePublication(LocalDateTime datePublication) { this.datePublication = datePublication; }

    public Student getAuteur() { return auteur; }
    public void setAuteur(Student auteur) { this.auteur = auteur; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public StudySession getSession() { return session; }
    public void setSession(StudySession session) { this.session = session; }

    public StudyGroup getGroupe() { return groupe; }
    public void setGroupe(StudyGroup groupe) { this.groupe = groupe; }
}


