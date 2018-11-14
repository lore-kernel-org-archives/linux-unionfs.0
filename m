Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181027200450.GA5909@thunk.org> <CAJfpegtCYkXiSYtw4dWGc=Fj2U3GaWiOiub+JmZ8pRXHNk4ERQ@mail.gmail.com>
 <20181029220404.GB15839@thunk.org> <CAOQ4uxiu6iS-VuEtPhequVp7Ukx7Kh0FUpECSXfkaZN==o7sJw@mail.gmail.com>
 <CAOQ4uxjsfgfo3rXtFKQk4A_fU2tvo38GFhzz7H9h1+R4trjd6Q@mail.gmail.com>
 <CAJfpeguV6Dwkm-CJieHKZWYK=uw3BYx9nW17KAs8uNJptmnchA@mail.gmail.com> <CACTyJpCx7y-5OOhk0P8ETQwp4_n-a1W1Dmc-1dHeE6j_cvdk7A@mail.gmail.com>
In-Reply-To: <CACTyJpCx7y-5OOhk0P8ETQwp4_n-a1W1Dmc-1dHeE6j_cvdk7A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 14 Nov 2018 14:09:01 +0200
Message-ID: <CAOQ4uxjRGpwGou3+BNUvMV6bCx8ysTyEESOR9RVY4Nc2QvkJjg@mail.gmail.com>
Subject: Re: overlayfs 4.19: unable to make backup link: Invalid cross-device link
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: =?UTF-8?Q?Maciej_Zi=C4=99ba?= <maciekz82@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>, Mark Salyzyn <salyzyn@android.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Nov 14, 2018 at 12:28 PM Maciej Zi=C4=99ba <maciekz82@gmail.com> wr=
ote:
>
> Hi :)
>
> I'm not sure which part is relevant, so I'm sending the entire dmesg outp=
ut as well as the docker messages. I hope it will be useful.
>

Thanks for the info!

Problem is ovl_set_redirect() inside ovl_link() is missing
ovl_override_creds().

Can you try the patch below?

Reason that unionmount-testsuite didn't catch this is because
it is run as root.

Vivek, Mark,

Either of you care to implement dropping privileges for the duration
of unionmount-testsuite test cases (in between mounts and unmounts)?

Thanks,
Amir.

---

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index c6289147c787..82c129bfe58d 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -651,6 +651,18 @@ static int ovl_symlink(struct inode *dir, struct
dentry *dentry,
        return ovl_create_object(dentry, S_IFLNK, 0, link);
 }

+static int ovl_set_link_redirect(struct dentry *dentry)
+{
+       const struct cred *old_cred;
+       int err;
+
+       old_cred =3D ovl_override_creds(dentry->d_sb);
+       err =3D ovl_set_redirect(dentry, false);
+       revert_creds(old_cred);
+
+       return err;
+}
+
 static int ovl_link(struct dentry *old, struct inode *newdir,
                    struct dentry *new)
 {
@@ -670,7 +682,7 @@ static int ovl_link(struct dentry *old, struct
inode *newdir,
                goto out_drop_write;

        if (ovl_is_metacopy_dentry(old)) {
-               err =3D ovl_set_redirect(old, false);
+               err =3D ovl_set_link_redirect(old);
                if (err)
                        goto out_drop_write;
        }
