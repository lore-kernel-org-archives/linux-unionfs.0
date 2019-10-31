Return-Path: <vgoyal@redhat.com>
Date: Thu, 31 Oct 2019 09:20:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] ovl: improving copy-up efficiency for big sparse file
Message-ID: <20191031132017.GA7308@redhat.com>
References: <20191030124431.11242-1-cgxu519@mykernel.net>
 <CAOQ4uxh670WFhwpQyPFTB2nUCSc9n1VmuyPOfdqiBSsq6GxLpQ@mail.gmail.com>
 <16e204de70e.cefd69461771.2205150443916624303@mykernel.net>
 <CAOQ4uxhdSXAvFQfhzZpBC=Xmmo9y+3AOU1o-tOWsLtr2ntU6Ag@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhdSXAvFQfhzZpBC=Xmmo9y+3AOU1o-tOWsLtr2ntU6Ag@mail.gmail.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chengguang Xu <cgxu519@mykernel.net>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 31, 2019 at 08:53:15AM +0200, Amir Goldstein wrote:
[..]
> >  > > +
> >  > > +       if (!error && set_size) {
> >  > > +               inode_lock(new->dentry->d_inode);
> >  > > +               error =3D ovl_set_size(new->dentry, stat);
> >  > > +               inode_unlock(new->dentry->d_inode);
> >  > > +       }
> >  >
> >  > I see no reason to repeat this code here.
> >  > Two options:
> >  > 1. always set_size at the end of ovl_copy_up_inode()
> >  >     what's the harm in that?
> >
> > I think at least it's not suitable for directory.
> >
> >
> >  > 2. set boolean c->set_size here and check it at the end
> >  >     of ovl_copy_up_inode() instead of checking c->metacopy
> >  >
> >
> > I don't understand why 'c->set_size' can replace 'c->metacopy',
> >
>=20
> I did not explain myself well.
>=20
> This should be enough IMO:
>=20
> @@ -483,7 +483,7 @@ static int ovl_copy_up_inode(struct
> ovl_copy_up_ctx *c, struct dentry *temp)
>         }
>=20
>         inode_lock(temp->d_inode);
> -       if (c->metacopy)
> +       if (S_ISREG(c->stat.mode))
>                 err =3D ovl_set_size(temp, &c->stat);

Hi Amir,

Why do we need this change. c->metacopy is set only for regular files.

ovl_need_meta_copy_up() {
        if (!S_ISREG(mode))
                return false;
}

Even if there is a reason, this change should be part of a separate patch.
What connection does it have to skip holes while copying up.

Thanks
Vivek
