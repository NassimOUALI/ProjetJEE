package com.studysync.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "study_groups")
public class StudyGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nom; // name

    @Column(length = 1000)
    private String description;

    @Column(nullable = false)
    private LocalDateTime dateCreation = LocalDateTime.now();

    @Column(nullable = false)
    private boolean estOuvert = true; // isOpen

    // Creator
    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "createur_id")
    private Student createur;

    // Members
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "group_members",
            joinColumns = @JoinColumn(name = "group_id"),
            inverseJoinColumns = @JoinColumn(name = "student_id")
    )
    private Set<Student> membres = new HashSet<>();

    // Subjects (many-to-many to allow reuse across groups)
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "group_subjects",
            joinColumns = @JoinColumn(name = "group_id"),
            inverseJoinColumns = @JoinColumn(name = "subject_id")
    )
    private Set<Subject> sujets = new HashSet<>();

    public Long getId() { return id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }

    public boolean isEstOuvert() { return estOuvert; }
    public void setEstOuvert(boolean estOuvert) { this.estOuvert = estOuvert; }

    public Student getCreateur() { return createur; }
    public void setCreateur(Student createur) { this.createur = createur; }

    public Set<Student> getMembres() { return membres; }
    public void setMembres(Set<Student> membres) { this.membres = membres; }

    public Set<Subject> getSujets() { return sujets; }
    public void setSujets(Set<Subject> sujets) { this.sujets = sujets; }
}


