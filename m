From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Overlayfs @ Containers and checkpoint/restart micro-conference
 at LPC2018
Date: Tue, 11 Sep 2018 08:13:40 -0700
Message-ID: <1536678820.3174.11.camel@HansenPartnership.com>
References: <CAOQ4uxih7rPPLquJZFL9HtSbUFi-cCOR21qH4_-ORxxLKGsLXg@mail.gmail.com>
         <20180909091549.yekfuds633afhrgw@mailbox.org>
         <20180911135259.GB27845@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911135259.GB27845@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, Christian Brauner <christian@brauner.io>
Cc: containers@lists.linuxfoundation.org, Miklos Szeredi <miklos@szeredi.hu>, "zhangyi (F)" <yi.zhang@huawei.com>, Netdev <netdev@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, lxc-users@lists.linuxcontainers.org, LSM List <linux-security-module@vger.kernel.org>, lxc-devel@lists.linuxcontainers.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, 2018-09-11 at 09:52 -0400, Vivek Goyal wrote:
> On Sun, Sep 09, 2018 at 11:18:54AM +0200, Christian Brauner wrote:
> [..]
> > My team hast just started to be more involved with shifts
> > development a few months back. Overlayfs is definitely an
> > inspiration and we even once thought about making shifts an
> > extension of overlayfs. Seth Forshee on my team is currently
> > actively working on shifts and getting a POC ready.
> > When he has a POC based on James' patchset there will be an RFC
> > that will go to fsdevel and all parties of interest.
> > There will also be an update on shifts development during the
> > microconf. So even more reason for developers from overlayfs to
> > stop by.
> 
> So we need both shiftfs and overlayfs in container deployments,
> right?

Well, no; only docker style containers need some form of overlay graph
driver, but even there it doesn't have to be the overlayfs one.  When I
build unprivileged containers, I never use overlays so for me having to
use it will be problematic as it would be even in docker for the non-
overlayfs graph drivers.

Perhaps we should consider this when we look at the use cases.

> shiftfs to make sure each container can run in its own user namespace
> and uid/gid mappings can be setup on the fly and overlayfs to provide
> union of multiple layers and copy on write filesystem. I am assuming
> that shiftfs is working on top of overlayfs here?
> 
> Doing shifting at VFS level using mount API was another idea
> discussed at last plumbers. I saw David Howells was pushing all the
> new mount API patches. Not sure if he ever got time to pursue
> shifting at VFS level.

I wasn't party to the conversation, but when I discussed it with Ted
(who wants something similar for a feature changing bind mount) we need
the entire VFS api to be struct path based instead of dentry/inode
based.  That's the way it's going, but we'd need to get to the end
point so we have a struct vfsmnt available for every VFS call.

> BTW, now we have metadata only copy up patches in overlayfs as
> well(4.19-rc). That speeds up chown operation with overlayfs,
> needed for changing ownership of files in images for making sure
> they work fine with user namespaces. In my simple testing in a VM,
> a fedora image was taking around 30 seconds to chown. With metadata
> only copy up that time drops to around 2-3 seconds. So till shiftfs
> or shiting at VFS level gets merged, it can be used as a stop gap
> solution.

Most of the snapshot based filesystem (btrfs, xfs) do this without any
need for overlayfs.

James
