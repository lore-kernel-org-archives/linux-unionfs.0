From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Overlayfs @ Containers and checkpoint/restart micro-conference
 at LPC2018
Date: Tue, 11 Sep 2018 11:36:30 -0400
Message-ID: <20180911153630.GB21805@redhat.com>
References: <CAOQ4uxih7rPPLquJZFL9HtSbUFi-cCOR21qH4_-ORxxLKGsLXg@mail.gmail.com>
 <20180909091549.yekfuds633afhrgw@mailbox.org>
 <20180911135259.GB27845@redhat.com>
 <1536678820.3174.11.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536678820.3174.11.camel@HansenPartnership.com>
Sender: netdev-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christian Brauner <christian@brauner.io>, containers@lists.linuxfoundation.org, Miklos Szeredi <miklos@szeredi.hu>, "zhangyi (F)" <yi.zhang@huawei.com>, Netdev <netdev@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, lxc-users@lists.linuxcontainers.org, LSM List <linux-security-module@vger.kernel.org>, lxc-devel@lists.linuxcontainers.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Sep 11, 2018 at 08:13:40AM -0700, James Bottomley wrote:
> On Tue, 2018-09-11 at 09:52 -0400, Vivek Goyal wrote:
> > On Sun, Sep 09, 2018 at 11:18:54AM +0200, Christian Brauner wrote:
> > [..]
> > > My team hast just started to be more involved with shifts
> > > development a few months back. Overlayfs is definitely an
> > > inspiration and we even once thought about making shifts an
> > > extension of overlayfs. Seth Forshee on my team is currently
> > > actively working on shifts and getting a POC ready.
> > > When he has a POC based on James' patchset there will be an RFC
> > > that will go to fsdevel and all parties of interest.
> > > There will also be an update on shifts development during the
> > > microconf. So even more reason for developers from overlayfs to
> > > stop by.
> > 
> > So we need both shiftfs and overlayfs in container deployments,
> > right?
> 
> Well, no; only docker style containers need some form of overlay graph
> driver, but even there it doesn't have to be the overlayfs one.  When I
> build unprivileged containers, I never use overlays so for me having to
> use it will be problematic as it would be even in docker for the non-
> overlayfs graph drivers.

Hi James,

Ok. For us, overlayfs is now default for docker containers as it was
much faster as compared to devicemapper and vfs (due to page cache
sharing). So please keep in mind overlayfs graph driver use case 
as well while designing a solution.

For non docker containers, I am assuming all the image is in one directory
so no union is required. Also these probably are read-only containers
or this image directory is not shared with other containers for it to
work.

> 
> Perhaps we should consider this when we look at the use cases.
> 
> > shiftfs to make sure each container can run in its own user namespace
> > and uid/gid mappings can be setup on the fly and overlayfs to provide
> > union of multiple layers and copy on write filesystem. I am assuming
> > that shiftfs is working on top of overlayfs here?
> > 
> > Doing shifting at VFS level using mount API was another idea
> > discussed at last plumbers. I saw David Howells was pushing all the
> > new mount API patches. Not sure if he ever got time to pursue
> > shifting at VFS level.
> 
> I wasn't party to the conversation, but when I discussed it with Ted
> (who wants something similar for a feature changing bind mount) we need
> the entire VFS api to be struct path based instead of dentry/inode
> based.  That's the way it's going, but we'd need to get to the end
> point so we have a struct vfsmnt available for every VFS call.

Ok, thanks. So mappings will be per mount and available in vfsmnt and
hence pass around path so that one can get to vfsmnt (instead of
dentry/inode). Makes sense.

> 
> > BTW, now we have metadata only copy up patches in overlayfs as
> > well(4.19-rc). That speeds up chown operation with overlayfs,
> > needed for changing ownership of files in images for making sure
> > they work fine with user namespaces. In my simple testing in a VM,
> > a fedora image was taking around 30 seconds to chown. With metadata
> > only copy up that time drops to around 2-3 seconds. So till shiftfs
> > or shiting at VFS level gets merged, it can be used as a stop gap
> > solution.
> 
> Most of the snapshot based filesystem (btrfs, xfs) do this without any
> need for overlayfs.

Right. But they don't share page cache yet (same with devicemapper). So
till we get page cache sharing in these file systems, overlayfs still
has the advantage of being able to launch many more containers using
same image with smaller memory requirements (and its faster too as image
does not have to be read from disk).

Thanks
Vivek
