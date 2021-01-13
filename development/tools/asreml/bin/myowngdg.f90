      program MYOWNDGD
!        Sample for using own.
!        This version creates an AR1 or AR2 correlation matrix

       IMPLICIT NONE
       INTEGER MXGAM, DIMX
       PARAMETER (MXGAM=2)
       PARAMETER (DIMX=10000)
       DOUBLE PRECISION X(DIMX),GAMMA(MXGAM),DET
       CHARACTER *72 BASENAME
       INTEGER NV,NGAM,OPT,IFRM

       INTEGER I,J,K,LL,LENBN
       DOUBLE PRECISION C0,C1,C2
!      ASREML writes  BASENAME.own
!             runs    MYOWNGDG BASENAME
!
!             reads   BASENAME.gdg
! ------------------------------------------
!      First obtain BASENAME
! Unix & DIgital Fortran
       CALL GETARG(1,BASENAME)

! Lahey
!      CALL GETCL(BASENAME)
       
       LENBN=INDEX(BASENAME,' ')

! ------------------------------------------
!      NOW READ   BASENAME.own
      BASENAME(LENBN:)='.own'
      OPEN(21,file=BASENAME,status='old',err=920)
      BASENAME(LENBN:)='.gdg'

      READ(21,21,ERR=930,END=930) NV,NGAM,OPT
 21   FORMAT(4I5)
      IF(NGAM.GT.MXGAM) GOTO 930

      READ(21,22,ERR=930,END=930) (GAMMA(I),I=1,NGAM)
 22   FORMAT(6D13.7)

      CLOSE(21)

! ------------------------------------------
!     This is where you must define the G matrix (here for AR1 and AR2)
       
      LL=NV*(NV+1)/2

!     IFRM  indicates the format of the matrices.
!        0  is the default dense form
!        1  is Sparce format: each line has  ROW  COL VALUE
!       -1  is Sparce format Inverse
!       NV  is Banded form:  11 12 13 14 15 ...
!      -NV  is Banded form Inverse.

!   This file is written to demonstrate these forms since an AR structure
!        is banded,  its inverse is sparse.
!        For this demonstration choose one of the next three lines

      IFRM=0
      IFRM=-1
!      IFRM=NV

      OPEN(21,file=BASENAME,status='unknown',err=950)

      WRITE(21,21) NV,NGAM,OPT,IFRM

      WRITE(21,22) (GAMMA(I),I=1,NGAM)

      IF(IFRM.EQ.0) THEN
      IF(NGAM.EQ.0) THEN
!           FORM IDENTITY
         DO 40 I=1,LL
 40         X(I)=0D0
         DO 44 I=1,NV
 44         X(I+(I+1)/2)=1D0

      ELSE IF(NGAM.EQ.1) THEN
!                                              AR1
         IF(GAMMA(1).GT..999) GAMMA(1)=.999
         X(LL)=1D0
         DO 60 I=1,NV-1
60          X(LL-I)=X(LL-I+1)*GAMMA(1)

         K=0
         DO 80 I=1,NV-1
           K=K+I
           DO 70 J=1,I
 70          X(K+1-J)=X(LL+1-J)
 80      CONTINUE


      ELSE IF(NGAM.EQ.2) THEN
!                                              AR2
	 IF(GAMMA(1).GT..999) GAMMA(1)=.999
         IF(GAMMA(2).GT..999) GAMMA(2)=.999
         X(LL)=1D0
         X(LL-1)=GAMMA(1)/(1d0-GAMMA(2))
         
         DO 160 I=2,NV-1
 160          X(LL-I)=X(LL-I+1)*GAMMA(1)+X(LL-I+2)*GAMMA(2)

         K=0
         DO 180 I=1,NV-1
           K=K+I
           DO 170 J=1,I
 170          X(K+1-J)=X(LL+1-J)
 180      CONTINUE
      ELSE
           GOTO 940
      ENDIF
! ------------------------------------------

      WRITE(21,22) (X(I),I=1,LL)
! ------------------------------------------
!      NOW WRITE DERIVATIVES

       IF(NGAM.EQ.1) THEN

         X(LL)=0D0
         DO 260 I=1,NV-1
260          X(LL-I)=I*X(LL-I)/GAMMA(1)

         K=0
         DO 280 I=1,NV-1
           K=K+I
           DO 270 J=1,I
 270          X(K+1-J)=X(LL+1-J)
 280      CONTINUE
      WRITE(21,22) X(1:LL)

      ELSE IF(NGAM.EQ.2) THEN

         X(LL)=0D0
	 X(LL+1)=X(LL-1)
         X(LL-1)=1D0/(1D0-GAMMA(2))
         
         DO 360 I=2,NV-1
!                      HOLD  R matrix so can use values
	      X(LL+I)=X(LL-I)
 360          X(LL-I)=X(LL-I+1)*GAMMA(1)+X(LL+I-1)+X(LL-I+2)*GAMMA(2)

         K=0
         DO 380 I=1,NV-1
           K=K+I
           DO 370 J=1,I
 370          X(K+1-J)=X(LL+1-J)
 380      CONTINUE
      WRITE(21,22) (X(I),I=1,LL)

         X(LL-1)=X(LL+1)/(1D0-GAMMA(2))
         X(LL-2)=X(LL-1)*GAMMA(1)+1D0+X(LL-I+2)*GAMMA(2)
!        write(22) X(LL-1),X(LL+1),GAMMA(2) 
         DO 460 I=3,NV-1
 460          X(LL-I)=X(LL-I+1)*GAMMA(1)+X(LL+I-2)+X(LL-I+2)*GAMMA(2)

         K=0
         DO 480 I=1,NV-1
           K=K+I
           DO 470 J=1,I
 470          X(K+1-J)=X(LL+1-J)
 480      CONTINUE
      WRITE(21,22) (X(I),I=1,LL)
      ENDIF

! ===========================================
      ELSE IF (IFRM.EQ.NV) THEN
!      --------------------------------   BANDED FORM
       IF(NGAM.EQ.1) THEN
         X(1)=1.
       DO  510 I=2,NV
510      X(I)=X(I-1)*GAMMA(1)
       WRITE(21,22) X(1:NV)

!          Put derivative wrt gamma2 in X(NV+1:NV+NV)

       DO  I=1,NV
         X(I)=(I-1)*X(I)/GAMMA(1)
         ENDDO
         WRITE(21,22) X(1:NV)
       ELSE IF(NGAM.EQ.2) THEN     ! AR2
         X(1)=1.
         X(2)=gamma(1)/(1.-GAMMA(2))
       DO   I=3,NV
          X(I)=X(I-1)*GAMMA(1)+X(I-2)*GAMMA(2)
          ENDDO
       WRITE(21,22) X(1:NV)

!          Put derivative wrt gamma2 in X(NV+1:NV+NV)

         X(NV+1)=0.
         X(NV+2)=X(2)/GAMMA(1)

       DO  I=3,NV
         X(NV+I)=X(I-1)+X(NV+I-1)*GAMMA(1)+X(NV+I-2)*GAMMA(2)
         ENDDO
         WRITE(21,22) X(NV+1:NV+NV)
         X(NV+2)=X(2)*X(NV+2)
       DO  I=3,NV
         X(NV+I)=X(I-2)+X(NV+I-1)*GAMMA(1)+X(NV+I-2)*GAMMA(2)
         ENDDO
         WRITE(21,22) X(NV+1:NV+NV)

       ENDIF

! ===========================================
      ELSE  IF (IFRM.EQ.-1) THEN
!      -----------------------------   SPARSE  FORM

!            SPARSE INVERSE FORM
       IF(NGAM.EQ.1) THEN
!    Inverse has   
       DET=1./(1.-GAMMA(1)**2)
       WRITE(21,611) 1,1,DET
 611   FORMAT(I5,I5,G18.10)     ! READ free format so must be space separated

       DO I=2,NV-1
          WRITE(21,611) I,I-1,-DET*GAMMA(1)
          WRITE(21,611) I,I,DET*(1.+GAMMA(1)**2)
          ENDDO

       WRITE(21,611) NV,NV-1,-DET*GAMMA(1)
       WRITE(21,611) NV,NV,DET

!   NOW DERIVATIVE
       C1=2.*GAMMA(1)*DET**2
       WRITE(21,611) 1,1,C1

           C2=-DET-GAMMA(1)*C1

           C0=(1.+GAMMA(1)**2)*C1 + DET*2.*GAMMA(1)
       DO I=2,NV-1
          WRITE(21,611) I,I-1,C2
          WRITE(21,611) I,I,C0
          ENDDO

       WRITE(21,611) NV,NV-1,C2
       WRITE(21,611) NV,NV,C1


       ELSE IF(NGAM.EQ.2) THEN
       DET=((1.0-GAMMA(2))**2-GAMMA(1)**2)*(1.+GAMMA(2))
       C0=DET/(1.-GAMMA(2))
       C1=-2.*GAMMA(1)*(1.+GAMMA(2))/(1.-GAMMA(2))
       C2=-2.*(GAMMA(2)+ GAMMA(1)**2/(1.-GAMMA(2))**2)

       WRITE(21,611) 1,1,1./C0
       WRITE(21,611) 2,1,-GAMMA(1)/C0
       WRITE(21,611) 2,2,(1.+GAMMA(1)**2)/C0
       DO I=3,NV-2
       WRITE(21,611) I,I-2,-GAMMA(2)/C0
       WRITE(21,611) I,I-1,-GAMMA(1)*(1.-GAMMA(2))/C0
       WRITE(21,611) I,I  ,(1.+GAMMA(1)**2+GAMMA(2)**2)/C0
       ENDDO
       WRITE(21,611) NV-1,NV-3,-GAMMA(2)/C0
       WRITE(21,611) NV-1,NV-2,-GAMMA(1)*(1.-GAMMA(2))/C0
       WRITE(21,611) NV-1,NV-1,(1.+GAMMA(1)**2)/C0

       WRITE(21,611) NV,NV-2,-GAMMA(2)/C0
       WRITE(21,611) NV,NV-1,-GAMMA(1)/C0

       WRITE(21,611) NV,NV,1./C0

!            Derivatives GAMMA(1)

       WRITE(21,611) 1,1,-C1/C0/C0
       WRITE(21,611) 2,1,-(1./C0-GAMMA(1)*C1/C0/C0)
       WRITE(21,611) 2,2,(2*GAMMA(1)                                     &
     &               -C1*((1.+GAMMA(1)**2)/C0))/C0
       DO I=3,NV-2
       WRITE(21,611) I,I-2,GAMMA(2)*C1/C0/C0
       WRITE(21,611) I,I-1,-(1.-GAMMA(2)-C1*GAMMA(1)*(1.-GAMMA(2))/C0)   &
     &                      /C0
       WRITE(21,611) I,I  ,(2*GAMMA(1)-C1*                               &
     &              (1.+GAMMA(1)**2+GAMMA(2)**2)/C0)/C0
       ENDDO
       WRITE(21,611) NV-1,NV-3,GAMMA(2)*C1/C0/C0
       WRITE(21,611) NV-1,NV-2,-(1.-GAMMA(2)-                            &
     &                   C1*GAMMA(1)*(1.-GAMMA(2))/C0)/C0
       WRITE(21,611) NV-1,NV-1,(2*GAMMA(1)                               &
     &               -C1*((1.+GAMMA(1)**2)/C0))/C0

       WRITE(21,611) NV,NV-2,GAMMA(2)*C1/C0/C0
       WRITE(21,611) NV,NV-1,-(1./C0-GAMMA(1)*C1/C0/C0)

       WRITE(21,611) NV,NV,-C1/C0/C0

!            Derivatives GAMMA(2)
       WRITE(21,611) 1,1,-C2/C0/C0
       WRITE(21,611) 2,1,GAMMA(1)*C2/C0/C0
       WRITE(21,611) 2,2,-C2*(1.+GAMMA(1)**2)/C0/C0
       DO I=3,NV-2
       WRITE(21,611) I,I-2,-(1.+C2*(-GAMMA(2)/C0))/C0
       WRITE(21,611) I,I-1, (GAMMA(1)+C2*(GAMMA(1)*(1.-GAMMA(2))/C0))/C0
       WRITE(21,611) I,I  , (2.*GAMMA(2)-C2*((1.+GAMMA(1)**2+           &
     &                       GAMMA(2)**2)/C0))/C0
       ENDDO
       WRITE(21,611) NV-1,NV-3,-(1.+C2*(-GAMMA(2)/C0))/C0
       WRITE(21,611) NV-1,NV-2, (GAMMA(1)+C2*(GAMMA(1)*(1.-GAMMA(2))    &
     &                          /C0))/C0
       WRITE(21,611) NV-1,NV-1,-C2*(1.+GAMMA(1)**2)/C0/C0

       WRITE(21,611) NV,NV-2,-(1.+C2*(-GAMMA(2)/C0))/C0
       WRITE(21,611) NV,NV-1, GAMMA(1)*C2/C0/C0
       WRITE(21,611) NV,NV,-C2/C0/C0

       ENDIF
      ENDIF
       
      CLOSE(21)

!     This bit of code designed to make sure file is properly closed before returning
      OPEN(22,FILE=BASENAME,STATUS='OLD',ERR=950)
      READ(22,21,err=950) I
      CLOSE(22)

! ------------------------------------------
       STOP
910    STOP 'MYOWNGDG has no BASENAME argument on command line'
920    STOP 'MYOWNGDG could not open BASENAME.own'
930    STOP 'MYOWNGDG failed to read BASENAME.own'
940    STOP 'MYOWNGDG has invalid/inconsistent data in BASENAME.own'
950    STOP 'MYOWNGDG could not open BASENAME.gdg'
960    STOP 'MYOWNGDG has no BASENAME argument on command line'
       END
