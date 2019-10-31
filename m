Return-Path: <cgxu519@mykernel.net>
Date: Thu, 31 Oct 2019 17:19:45 +0800
From: Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
Message-ID: <16e211d1b09.13a4295c32260.2957618455193007862@mykernel.net>
In-Reply-To: <CAOQ4uxihFu+ObkUxrZ3kzM1G5NrRauhgGxupuBarbAJaXSS_Zg@mail.gmail.com>
References: <20191030124431.11242-1-cgxu519@mykernel.net> <CAOQ4uxh670WFhwpQyPFTB2nUCSc9n1VmuyPOfdqiBSsq6GxLpQ@mail.gmail.com>
 <16e204de70e.cefd69461771.2205150443916624303@mykernel.net>
 <CAOQ4uxhdSXAvFQfhzZpBC=Xmmo9y+3AOU1o-tOWsLtr2ntU6Ag@mail.gmail.com> <16e20ebaea1.e98a5dc22147.7820959102365222617@mykernel.net> <CAOQ4uxihFu+ObkUxrZ3kzM1G5NrRauhgGxupuBarbAJaXSS_Zg@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: improving copy-up efficiency for big sparse
 file
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2019-10-31 17:06:24 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > I did not explain myself well.
 > >  >
 > >  > This should be enough IMO:
 > >  >
 > >  > @@ -483,7 +483,7 @@ static int ovl_copy_up_inode(struct
 > >  > ovl_copy_up_ctx *c, struct dentry *temp)
 > >  >         }
 > >  >
 > >  >         inode_lock(temp->d_inode);
 > >  > -       if (c->metacopy)
 > >  > +       if (S_ISREG(c->stat.mode))
 > >  >                 err =3D ovl_set_size(temp, &c->stat);
 > >  >         if (!err)
 > >  >                 err =3D ovl_set_attr(temp, &c->stat);
 > >  >
 > >  > There is no special reason IMO to try to spare an unneeded ovl_set_=
size
 > >  > if it simplifies the code a bit.
 > >
 > > We can try this but I'm afraid that someone could complain
 > > we do unnecessary ovl_set_size() in the case of full copy-up
 > > or data-end file's copy-up.
 > >
 > >
 >=20
 > There is no one to complain.
 > The cost of ovl_set_size() is insignificant compared to the cost of
 > copying data (unless I am missing something).
 > Please post a version as above and if Miklos finds it a problem,
 > we can add a boolean c->should_set_size to the copy up context, initiali=
ze
 > it: c->should_set_size =3D (S_ISREG(c->stat.mode) && c->stat.size)
 > and set it to false in case all data was copied.
 > I think that won't be necessary though.
 >=20

I forgot to mention that there are two callers of  ovl_copy_up_data()
and ovl_copy_up_meta_inode_data() even don't have logic to set size.
So do you still think set size in ovl_copy_up_inode() is simpler than
set size inside ovl_copy_up_data()?

Thanks,
Chengguang
