Return-Path: <vgoyal@redhat.com>
Date: Wed, 7 Mar 2018 08:30:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v12 10/17] ovl: Copy up meta inode data from lowest data
 inode
Message-ID: <20180307133046.GC5350@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
 <20180306205408.23383-11-vgoyal@redhat.com>
 <CAOQ4uxgaWsz9Ea6H-B_jxGeToX19fNR-ySuF5gn1CPPy_BB2jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgaWsz9Ea6H-B_jxGeToX19fNR-ySuF5gn1CPPy_BB2jA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 07, 2018 at 09:19:07AM +0200, Amir Goldstein wrote:

[..]
> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > index b48bd73786f1..d999813f9aeb 100644
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -221,6 +221,7 @@ bool ovl_dentry_weird(struct dentry *dentry);
> >  enum ovl_path_type ovl_path_type(struct dentry *dentry);
> >  void ovl_path_upper(struct dentry *dentry, struct path *path);
> >  void ovl_path_lower(struct dentry *dentry, struct path *path);
> > +void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
> >  enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
> >  struct dentry *ovl_dentry_upper(struct dentry *dentry);
> >  struct dentry *ovl_dentry_lower(struct dentry *dentry);
> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > index 19b936b0a551..22df74cb1def 100644
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -148,6 +148,20 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
> >         }
> >  }
> >
> 
> A comment here why  ovl_path_lowerdata is needed would be nice.

Ok, will add a comment.

Vivek
