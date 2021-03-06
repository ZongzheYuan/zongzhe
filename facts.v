Require Import CAS.basic. 
Require Import CAS.properties. 

Section Facts. 
Variable S : Type.
  Variable eq    : brel S.
  Variable ref   : brel_reflexive S eq. 
  Variable sym   : brel_symmetric S eq. 
  Variable trans : brel_transitive S eq.


Lemma brel_symmetric_false : 
  ∀ s t : S, (eq s t = false) → (eq t s = false).
Proof. intros s t H. case_eq(eq t s); intro K. 
       apply sym in K. rewrite K in H. discriminate H.
       reflexivity.
Qed.        
  

Lemma brel_transitive_f1 : 
  ∀ s t u: S, (eq s t = false) → (eq t u = true) → (eq s u = false).
Proof. intros s t u H1 H2.
       case_eq (eq s t); intro J1; case_eq (eq s u); intro J2.
       rewrite J1 in H1. exact H1. 
       reflexivity. 
       apply sym in J2. 
       assert (J3 := trans _ _ _ H2 J2). 
       apply sym in J3.
       rewrite J3 in H1. exact H1. 
       reflexivity. 
Qed.        

Lemma brel_transitive_f2 : 
  ∀ s t u: S, (eq s t = true) → (eq t u = false) → (eq s u = false).
Proof. intros s t u H1 H2.
       case_eq (eq t u); intro J1; case_eq (eq s u); intro J2.
       rewrite J1 in H2. exact H2. 
       reflexivity. 
       apply sym in J2. 
       assert (J3 := trans _ _ _ J2 H1). 
       apply sym in J3.
       rewrite J3 in H2. exact H2.
       reflexivity. 
Qed.

Definition brel_symmetric_f (S : Type) (r : brel S) := 
    ∀ s t : S, (r s t = false) → (r t s = false). 


Lemma bop_is_ann_unique : ∀ (s1 s2 : S) (b : binary_op S),  bop_is_ann S eq b s1 -> bop_is_ann S eq b s2 -> eq s1 s2 = true.             
Proof. intros s1 s2 b P Q. 
       destruct (Q s1) as [_ R1].
       destruct (P s2) as [L2 _]. 
       apply sym in L2. apply (trans _ _ _ L2 R1). 
Defined.                         

Lemma bop_is_id_unique : ∀ (s1 s2 : S) (b : binary_op S ), bop_is_id S eq b s1 -> bop_is_id S eq b s2 -> eq s1 s2 = true.             
Proof. intros s1 s2 b P Q. 
       destruct (Q s1) as [_ R1].
       destruct (P s2) as [L2 _]. 
       apply sym in R1. apply (trans _ _ _ R1 L2). 
Defined.                         





End Facts.