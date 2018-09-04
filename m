Return-Path: <vgoyal@redhat.com>
Date: Tue, 4 Sep 2018 13:37:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: What's the right/expected behavior with metacopy=off
Message-ID: <20180904173745.GG1469@redhat.com>
References: <20180904145453.GD1469@redhat.com>
 <CAOQ4uxi+3Rh=yh9LWUnR6p8kk-ko2i_YmGFhVxzcMjqCC-qX1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi+3Rh=yh9LWUnR6p8kk-ko2i_YmGFhVxzcMjqCC-qX1A@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Sep 04, 2018 at 06:32:38PM +0300, Amir Goldstein wrote:
> On Tue, Sep 4, 2018 at 5:54 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Hi Miklos/Amir,
> >
> > I have a query about metacopy behavior with metacopy=off.
> >
> > As of now, metacopy=off still continues to check for metacopy xattr,
> > and if a metacopy file is found, data copy up takes place when file
> > is opened for write. And there are other paths in getattr() for reporting
> > number of blocks of lower file etc.
> >
> > IOW, metacopy=off does not turn off metacopy functionality completely.
> > It only disables metacopy for new copy up operations. Anything which
> > is already metadata copy up (due to previous mounts), that will continue
> > to work as if metacopy=on was specified during mount.
> >
> > I am wondering is this the right way to do things. I did this because
> > we don't have a functionality to detect and warn if current mount options
> > are incompatible with existing state of file system. Ideally, I think
> > we should warn/error out if an fs is mounted with metacopy=off and it was
> > mounted with metacopy=on in the past. And metacopy=off should disable
> > metacopy path completely (irrespective of the fact whether previously
> > it was mounted with metacopy=on or not).
> >
> > Given we don't have such feature in overlayfs yet, I thought continuing
> > to honor metacopy files even if metacopy=off, will be path of least
> > surprise for a user.
> >
> > I want to revisit this question while we are still in -rc phase and
> > before it becomes a completely supported mode.
> >
> > What do you folks think about it.
> >
> 
> What is the threat model of attacker using metacopy?
> TBH, I don't fully understand the threat model with redirect_dir
> that required the addition of redirect_dir=nofollow.
> Who auto mounts an upper layer from USB drive over sensitive
> lower paths?

Hi Amir,

I don't have any examples. Miklos might have one.

> 
> Let's see, an attacker wants to access a file that is root owned 0600
> so attacker crafts a metacopy with its own ownership above the
> root owned file.
> 
> Now the same thing an attacker could do with a merge dir to get
> read/lookup access to a root owned directory, so metacopy does
> not introduce this alleged attack vector, but it enhances it with the
> ability to access files that are read-only for root.
> 
> If that threat is considered series to some users, I would advise
> against adding metacopy=follow/nofollow options and reusing
> existing ofs->config.redirect_follow to determine if data should
> be followed from a metacopy upper when metacopy=off.

Let me correct myself. metacopy=off, is checking for metacopy xattr
but in the end it is refusing to follow it because metacopy=off. I now
remember that either you or miklos had pointed out that metacopy is
like redirect and we should not follow it if metacopy=off.

                if (!ofs->config.metacopy) {
                        pr_warn_ratelimited("overlay: refusing to follow metacopy origin for (%pd2)\n",
                                            dentry);
                        goto out_put;
                }

> 
> The rational is that redirect_dir=follow/nofollow really only
> means behavior=usability/paranoia.

So what we probably need is metacopy=follow at some point of time. This
will cater to the need of people who don't want to create new metacopy
inodes but if one already exists, then they would like to follow it.

IOW, current options of metacopy=on/off seems to be fine and
metacopy=follow can be added when somebody asks for it.

meatacopy=off will detect that filesystem has metacopy xattr and warn
about it but not follow it.

There seem to be one odd downside of looking for xattrs in in
ovl_lookup(). From SELinux point of view, this requires "getattr"
permission. Say an operation "unlink" which only requires write permission
on the directory where file is, it might still fail if mounter does not
have "getattr" permission on file.

Current SELinux test suite seems to be running in this issue on 4.19-rc1.

https://github.com/SELinuxProject/selinux-kernel/issues/41

For now, I am making a case that give "getattr" permission to mounter
in SELinux policy. Other option could be that don't even look for
metacopy xattr if metacopy=off. But that means we lose the capability
to warn user about a configuration where metacopy=off but filesystem
has metacopy files.

At this point of time, I feel being able to warn users about it is
more practical approach.

Thanks
Vivek
