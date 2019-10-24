From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v14 1/5] Add flags option to get xattr method paired to __vfs_getxattr
Date: Thu, 24 Oct 2019 07:57:03 +0300
Message-ID: <CAOQ4uxis-oQSjKrtBDi-8BQ2M3ve3w8o-YVGRwWLnq+5JLUttA@mail.gmail.com>
References: <20191022204453.97058-1-salyzyn@android.com> <20191022204453.97058-2-salyzyn@android.com>
 <8CE5B6E8-DCB7-4F0B-91C1-48030947F585@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8CE5B6E8-DCB7-4F0B-91C1-48030947F585@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Mark Salyzyn <salyzyn@android.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, CIFS <linux-cifs@vger.kernel.org>, kernel-team@android.com, selinux@vger.kernel.org, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, ecryptfs@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-unionfs@vger.kernel.org

[excessive CC list reduced]

On Wed, Oct 23, 2019 at 11:07 AM Andreas Dilger via samba-technical
<samba-technical@lists.samba.org> wrote:
>
>
> On Oct 22, 2019, at 2:44 PM, Mark Salyzyn <salyzyn@android.com> wrote:
> >
> > Replace arguments for get and set xattr methods, and __vfs_getxattr
> > and __vfs_setaxtr functions with a reference to the following now
> > common argument structure:
> >
> > struct xattr_gs_args {
> >       struct dentry *dentry;
> >       struct inode *inode;
> >       const char *name;
> >       union {
> >               void *buffer;
> >               const void *value;
> >       };
> >       size_t size;
> >       int flags;
> > };
>

> > Mark,
> >
> > I do not see the first patch on fsdevel
> > and I am confused from all the suggested APIs
> > I recall Christoph's comment on v8 for not using xattr_gs_args
> > and just adding flags to existing get() method.
> > I agree to that comment.
>
> As already responded, third (?) patch version was like that,

The problem is that because of the waaay too long CC list, most revisions
of the patch and discussion were bounced from fsdevel, most emails
I did not get and cannot find in archives, so the discussion around
them is not productive.

Please resend patch to fsdevel discarding the auto added CC list
of all fs maintainers.

> gregkh@
> said it passed the limit for number of arguments, is looking a bit silly

Well, you just matched get() to set() args list, so this is not a strong
argument IMO.

> (my paraphrase), and that it should be passed as a structure. Two others
> agreed. We gained because both set and get use the same structure after
> this change (this allows a simplified read-modify-write cycle).

That sounds like a nice benefit if this was user API, but are there any
kernel users that intend to make use of that read-modify-write cycle?
I don't think so.

>
> We will need a quorum on this, 3 (structure) to 2 (flag) now (but really
> basically between Greg and Christoph?). Coding style issue: Add a flag,
> or switch to a common xattr argument  structure?
>

IIRC, Christoph was asking why the silly struct and not simply add flags
(as did I). He probably did not see Greg's comments due to the list bounce
issue. If I read your second hand description of Greg's reaction correctly,
it doesn't sound so strong opinionated as well.
Me, I can live with flags or struct - I don't care, but...

Be prepared that if you are going ahead with struct you are going to
suffer from bike shedding, which has already started and you will be
instructed (just now) to also fix all the relevant and missing Documentation.
If, on the other hand, you can get Greg and the rest to concede to adding
flags arg and match get() arg list to set() arg list, you will have a much
easier job and the patch line count, especially in fs code will be *much*
smaller - just saying.

Thanks,
Amir.
