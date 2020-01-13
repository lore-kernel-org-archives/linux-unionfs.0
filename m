From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: OverlaysFS offline tools
Date: Mon, 13 Jan 2020 21:07:45 +0100
Message-ID: <20200113200745.3ucquoj532jik6xc@wittgenstein>
References: <CAOQ4uxjFC81hikgg0WaF0Z3Mxkk3iDakKx2Ttuhp_L_2Tnc6xQ@mail.gmail.com>
 <20200108140611.GA1995@redhat.com>
 <70a7e65d-40a5-7940-0d4d-14cdbfef39bd@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51509 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgAMUIA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jan 2020 15:08:00 -0500
Content-Disposition: inline
In-Reply-To: <70a7e65d-40a5-7940-0d4d-14cdbfef39bd@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Daniel Walsh <dwalsh@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Amir Goldstein <amir73il@gmail.com>, StuartIanNaylor <rolyantrauts@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Linux Containers <containers@lists.linux-foundation.org>, "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, kmxz <kxzkxz7139@gmail.com>

On Mon, Jan 13, 2020 at 10:28:24AM -0500, Daniel Walsh wrote:
> On 1/8/20 9:06 AM, Vivek Goyal wrote:
> > On Wed, Jan 08, 2020 at 09:27:12AM +0200, Amir Goldstein wrote:
> >> [-fsdevel,+containers]
> >>
> >>> On Thu, Apr 18, 2019 at 1:58 PM StuartIanNaylor <rolyantrauts@gmail.com> wrote:
> >>>> Apols to ask here but are there any tools for overlayFS?
> >>>>
> >>>> https://github.com/kmxz/overlayfs-tools is just about the only thing I
> >>>> can find.
> >>> There is also https://github.com/hisilicon/overlayfs-progs which
> >>> can check and fix overlay layers, but it hasn't been updated in a while.
> >>>
> >> Hi Vivek (and containers folks),
> >>
> >> Stuart has pinged me on https://github.com/StuartIanNaylor/zram-config/issues/4
> >> to ask about the status of overlayfs offline tools.
> >>
> >> Quoting my answer here for visibility to more container developers:
> >>
> >> I have been involved with implementing many overlayfs features in the
> >> kernel in the
> >> past couple of years (redirect_dir,index,nfs_export,xino,metacopy).
> >> All of these features bring benefits to end users, but AFAIK, they are
> >> all still disabled
> >> by default in containers runtimes (?) because lack of tools support
> >> (e.g. migration
> >> /import/export). I cannot force anyone to use the new overlayfs
> >> features nor to write
> >> offline tools support for them.
> >>
> >> So how can we improve this situation?
> >>
> >> If the problem is development resources then I've had great experience
> >> in the past
> >> with OSS internship programs like Google summer of code (GSoC):
> >> Organizations, such as Redhat or mobyproject.org, can participate in the program
> >> by posting proposals for open source projects.
> >> Developers, such as myself, volunteer to mentors projects and students apply
> >> to work on them.
> >>
> >> IIRC, the timeline for GSoC for project proposals in around April. Applying as
> >> an organization could be before that.
> >>
> >> Vivek, since you are the only developer I know involved in containers runtime
> >> projects I am asking you, but really its a question for all container developers
> >> out there.
> >>
> >> Are you aware of missing features in containers that could be met by filling the
> >> gaps with overlayfs offline tools?
> > CCing Dan Walsh as he is taking care of podman and often I hear some of
> > the the complaints from him w.r.t what he thinks is missing. This is
> > not necessarily related to overlayfs offline tools.
> >
> > - Unpriviliged mounting of overlayfs.
> >  
> >   He wants to launch containers unpriviliged and hence wants to be able
> >   to mount overlayfs without being root in init_user_ns. I think Miklos
> >   posted some patches for that but not much progress after that.
> >
> >   https://patchwork.kernel.org/cover/11212091/
> >
> > - shiftfs
> >
> >   As of now they are relying on doing chown of the image but will really
> >   like to see the ability to shift uid/gids using shiftfs or using
> >   VFS layer solution.
> >
> > - Overlayfs redirect_dir is not compatible with image building
> >
> >   redirect_dir is not compatible with image building and I think that's
> >   one reason that its not used by default. And as metacopy is dependent
> >   on redirect_dir, its not used by default as well. It can be used for
> >   running containers though, but one needs to know that in advacnce.
> >
> >   So it will be good if that's fixed with redirect_dir and metacopy
> >   features and then there is higher chance that these features are
> >   enabled by default.
> >
> >   Miklos had some ides on how to tackle the issue of getting diff
> >   correctly with redirect_dir enabled.
> >
> >   https://www.spinics.net/lists/linux-unionfs/msg06969.html
> >
> >   Having said that, I think Dan Walsh has enabled metacopy by default
> >   in podman in certain configurations (for running containers and not
> >   for building images).
> >
> > Thanks
> > Vivek
> 
> Amir, Vivek did an excellent job of describing what we are attempting to
> do with OverlayFS in container tools.  My work centers around
> github.com/containers Specifically in podman(libpod), buildah, CRI-O,
> Skopeo, containers/storage and containers/image.
> 
> The Podman tool is our most popular tool and runs containers with
> metacopyup turned on by default, in at least Fedora and soon in RHEL8. 
> Not sure if it is turned on by default in Debian and Ubuntu releases, as
> well as OpenSUSE and other distros.
> 
> On of the biggest features of these container engines (runtimes) is that
> podman & Buildah can run rootless, using the user namespace. But sadly
> we can not use overlayfs for this, since mounting of overlayfs requires
> CAP_SYS_ADMIN.  As Vivek points out, Miklos is working to fix this.  For
> now we use a FUSE version of overlay called fuse_overlayfs, which can
> run rootless, but might not give us as good of performance as kernel
> overlayfs. 
> 
> The biggest feature I want to push for in container technologies is
> better support for User Namespace.  I want to use it for container
> separation, IE Each container would run with a different User
> Namespace.  This means that root in one container would be a different
> UID then Root is a different container.  Currently almost no one uses
> User Namespace for this kind of separation.  The difficulty is that the

Just to add a few more details here that seem to have fallen under
table.
This is only true for the application container world. LXD has supported
this feature for years and we run millions of container in production
including all non-x86 workloads on travis.
We've supported isolated idmaps since at least 2016 [1]. Here's a demo
of that feature too:
https://asciinema.org/a/293463

[1]: https://github.com/lxc/lxd/commit/bfe7296daa4f89fabf0c41c21a54009dfb05a709

> kernel does not support a shifting file system, so if I want to share
> the same base image image, (Lower directory) between multiple containers
> in different User Namespaces, the UIDs end up wrong.  We have hoped for
> a shifting file system for many years, but Overlay FS has never
> developed it, (Fuse-overlay has some support for it).  There is an
> effort in the kernel now to add a shifting file system, but I would bet
> this will take a long time to get implemented.  
> 
> The other option that we have built into our container engines is a
> "chowing" image.  Basically when a new container is started, in a new
> User Namespace, the container engine chowns the lower level to match the
> new user namespace and then sets up an overlay mount.  If the same image
> is used a second time, the container engine is smart enough to use the
> "chowned" image.  This chowning causes two problems on traditional
> Overlay systems.  One it is slow, since it is copying up all of the
> lower files to a new upper.  The second problem is now the kernel sees
> each executable/shared library as being different so process/memory
> sharing is broken in the kernel.  This means I get less containers
> running on a system do to memory.  The metacopyup feature of overlay
> solves both of these issues.  This is why we turn it on by default in
> Podman.  If I run podman in a new user namespace, in stead of it taking
> 30 seconds to chown the file system, it now takes < 2 seconds.
> 
> Sadly still almost no one is using User Namespace separated containers,
> because they are not on by default.  The issue is users need to pick out
> unigue ranges of UIDs for each container they create/launch, and almost
> no one does.  I would propose that we fix this by making Podman do it by

Again, this is only true for the application container world. LXD does
this automatically for you.

> default. The idea would be to allocate 2 Billion UIDs on a system and
> then have podman pick a range of 65K uids for each root running
> container that it creates.  Container/storage would keep track of the
> selection. 

That's how we do it right now. Our range is 1 billion ids currently.

Christian
