Return-Path: <olga.kornievskaia@gmail.com>
MIME-Version: 1.0
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-4-olga.kornievskaia@gmail.com> <20181027092750.GL6311@dastard>
 <CAN-5tyEeMrRVUyP61Vv-dwFUvm7q55Q3=NVJkeZN+XoCcAOCDQ@mail.gmail.com>
 <20181030090344.GN6311@dastard> <CAN-5tyHhTQ8bZk+DUrU0o1ZK3k9uhipiLPeOA3dYuXUG542mNw@mail.gmail.com>
In-Reply-To: <CAN-5tyHhTQ8bZk+DUrU0o1ZK3k9uhipiLPeOA3dYuXUG542mNw@mail.gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Tue, 30 Oct 2018 17:12:50 -0400
Message-ID: <CAN-5tyH-Fn0nU3FE_hG_YpjL08kQgVbJBOxwxKY74aRBg3Hxag@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] VFS: copy_file_range check validity of input
 source offset
Content-Type: text/plain; charset="UTF-8"
To: david@fromorbit.com
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Oct 30, 2018 at 5:10 PM Olga Kornievskaia
<olga.kornievskaia@gmail.com> wrote:
>
> On Tue, Oct 30, 2018 at 5:03 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, Oct 29, 2018 at 10:41:22AM -0400, Olga Kornievskaia wrote:
> > > On Sat, Oct 27, 2018 at 5:27 AM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Fri, Oct 26, 2018 at 04:10:48PM -0400, Olga Kornievskaia wrote:
> > > > > From: Olga Kornievskaia <kolga@netapp.com>
> > > > >
> > > > > Input source offset can't be beyond the end of the file.
> > > > >
> > > > > Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> > > > > ---
> > > > >  fs/read_write.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/fs/read_write.c b/fs/read_write.c
> > > > > index fb4ffca..b3b304e 100644
> > > > > --- a/fs/read_write.c
> > > > > +++ b/fs/read_write.c
> > > > > @@ -1594,6 +1594,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
> > > > >               }
> > > > >       }
> > > > >
> > > > > +     if (pos_in >= i_size_read(inode_in))
> > > > > +             return -EINVAL;
> > > > > +
> > > >
> > > > vfs_copy_file_range seems ot be missing a wide range of checks.
> > > > rlimit, s_maxbytes, LFS file sizes, etc. This is a write, so all the
> > > > checks in generic_write_checks() apply, right? And the same security
> > > > issues like stripping setuid bits, etc? And we need to touch
> > > > atime on the source file, too?
> > >
> > > Yes sound like needed checks.
> > >
> > > > We've just merged 5 or so patches in 4.19-rc8 and we're ready to
> > > > merge another ~30 patch series to fix all the stuff missing from the
> > > > clone/dedupe file range operations that make them safe and robust.
> > > > It seems like copy_file_range is all the checks it needs, too?
> > >
> > > Are you proposing to not do this check now in favor of the proper work
> > > that will do all of those checks you listed above?
> >
> > No, I'm saying that if you're adding one check, there's a whole heap
> > of checks that still need to be added, *especially* if this is going
> > to fall back to page cache copy between superblocks that may have
> > different limits and constraints.
> >
> > There's security issues in this API. They need to be fixed before we
> > allow it to do more and potentially expose more problems due to it's
> > wider capability.
>
> Before I totally give up on this feature, can you help me understand
> your concerns with allowing the generic copy_file_range via
> do_splice().
>
> I have mentioned I'm not a VFS expert thus I come from just looking at
> the available documentation and the code.
>
> I don't see any restrictions on the files being passed in the
> do_splice_direct(). There are no restrictions that they must be from
> the same filesystem or file system type. But perhaps this not the
> concern you had but more about checking validity of arguments?
>
> I have looked at Dave Wong's, if I'm not mistaken these 2 are the

apologizes Darrick Wong's patches.

> relevant patches:
> [PATCH 02/28] vfs: check file ranges before cloning files
>  -- a couple but not all checks apply to copy_file_range() .
> specifically, the offsets don't wrap and offset isn't past eof (as my
> patch suggests). Other checks have to do with aligned memory which I
> don't believe is needed or other dedup requirement that don't apply.
>
> [PATCH 04/28] vfs: strengthen checking of file range inputs to
> generic_remap_checks
>  -- these checks apply to the code once we fall back to the
> do_splice(). it looks to me that perhaps exporting
> generic_access_check_limits()/generic_write_check_limits so that they
> can be used by the copy_file_range when it get pulled in.
>
> Also, can you elaborate one what "security issues" are present in this
> API? Is it "stripping setuid bits" and so something like calling
> file_remove_priv() that should be done when the fallback to the
> do_splice_direct() happens?
>
> As for the atime, wouldn't the ->copy_file_range() be updating the
> file attributes? I guess for the fallback case, the attributes need to
> be updated.
>
> If those are checks/issues needed to be addressed and would then get
> the generic copy_file_range() in, I could give a go at a patch (or 2).
> >
> > > I can not volunteer
> > > to provide this comprehensive check.
> >
> > Why not?
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
