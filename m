Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD91C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 12:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D76B72065C
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 12:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgFEMoq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 08:44:46 -0400
Received: from relay.sw.ru ([185.231.240.75]:56600 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726429AbgFEMoq (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 08:44:46 -0400
Received: from [192.168.15.111] (helo=alex-laptop)
        by relay3.sw.ru with smtp (Exim 4.93)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1jhBi6-0001VS-Kd; Fri, 05 Jun 2020 15:44:34 +0300
Date:   Fri, 5 Jun 2020 15:44:38 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Andrey Vagin <avagin@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Vasiliy Averin <vvs@virtuozzo.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] overlayfs: C/R enhancements
Message-Id: <20200605154438.408e5dc5522170c50463bbec@virtuozzo.com>
In-Reply-To: <CAOQ4uxhhNx0VxJB=eLoPX+wt15tH3-KLjGuQem4h_R=0nfkAiA@mail.gmail.com>
References: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
        <CAOQ4uxhGswjxZjc3mN7K99pPrDgMV9_194U46b2MgszZnq1SDw@mail.gmail.com>
        <AM6PR08MB36394A00DC129791CC89296AE8890@AM6PR08MB3639.eurprd08.prod.outlook.com>
        <CAOQ4uxisdLt-0eT1R=V1ihagMoNfjiTrUdcdF2yDgD4O94Zjcw@mail.gmail.com>
        <fb79be2c-4fc8-5a9d-9b07-e0464fca9c3f@virtuozzo.com>
        <CAOQ4uxhhNx0VxJB=eLoPX+wt15tH3-KLjGuQem4h_R=0nfkAiA@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Dear Amir,

We actively discussed about patches with Pavel, so with your favour I'll try to answer (partially) to some of your comments.

On Fri, 5 Jun 2020 13:21:40 +0300
Amir Goldstein <amir73il@gmail.com> wrote:

> On Fri, Jun 5, 2020 at 11:41 AM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
> >
> >
> >
> > On 6/5/20 5:35 AM, Amir Goldstein wrote:
> > > On Fri, Jun 5, 2020 at 12:34 AM Alexander Mikhalitsyn
> > > <alexander.mikhalitsyn@virtuozzo.com> wrote:
> > >>
> > >> Hello,
> > >>
> > >>> But overlayfs won't accept these "output only" options as input args,
> > >> which is a problem.
> > >>
> > >> Will it be problematic if we simply ignore "lowerdir_mnt_id" and "upperdir_mnt_id" options in ovl_parse_opt()?
> > >>
> > >
> > > That would solve this small problem.
> >
> > This is not a big problem actually as these options shown in mountinfo
> > for overlay had been "output only" forever,
> > please see these two examples below:
> >
> > a) Imagine you've mounted overlay with relative paths and forgot (or you
> > never known as you are another user) where your cwd was at the moment of
> > mount syscall. - How would you use those options as "input" to create
> > the same overlay mount somethere else (bind-mounting not involved)?
> >
> > b) Imagine you've mounted overlay with absolute paths and someone (other
> > user) overmounted lower (upper/workdir) paths for you, all directory
> > structure would be the same on overmount but yet files are different. -
> > How would you use those options from mountinfo as "input" ones?
> >
> > We try to make them much closer to "input" ones.
> 
> 
> That is not what I meant by "output only"
> I meant invalid input options as in EINVAL not ENOENT

Yes, it's just as example of existing inconsistency between mount-time/show-time
options. But yes, errno will be different. As it was said before we can simply
ignore new options at mount time.

> 
> >
> > Agreed, we should ignore *_mnt_id on mount because paths identify mounts
> > at the time of mount call.
> >
> > >
> > >>> Wouldn't it be better for C/R to implement mount options
> > >> that overlayfs can parse and pass it mntid and fhandle instead
> > >> of paths? >>
> > >> Problem is that we need to know on C/R "dump stage" which mounts are used on lower layers and upper layer. Most likely I don't understand something but I can't catch how "mount-time" options will help us.
> > >
> > > As you already know from inotify/fanotify C/R fhandle is timeless, so
> > > there would be no distinction between mount time and dump time.
> >
> > Pair of fhandle+mnt_id looks an equivalent to path+mnt_id pair, CRIU
> > will just need to open fhandle+mnt_id with open_by_handle_at and
> > readlink to get path on dump and continue to use path+mnt_id as before.
> > (not too common with fhandles but it's my current understanding)
> >
> > But if you take a look on (a) and (b) again, the regular user does not
> > see full information about overlay mount in /proc/pid/mountinfo, they
> > can't just take a look on it and understand from there it comes from.
> > Resolving fhandle looks like a too hard task for a user.
> >
> 
> Right, and we need to provide regular user needs in parallel to
> providing C/R needs. understood.
> 
> > > About mnt_id, your patches will cause the original mount-time mounts to be busy.
> > > That is a problem as well.
> >
> > Children mounts lock parent, open files lock parent. Another analogy is
> > a loop device which locks the backing file mount (AFAICS). Anyway one
> > can lazy umount, can't they? But I'm not too sure for this one, maybe
> > you can share more implications of this problem?
> >
> 
> Overlayfs mounts are internal not children mounts in the namespace,
> so no open files hold reference the mounts in the namespace (AFAICS).
> 
> This use case will break:
> 
>   mount /dev/vdf /vdf
>   mkdir /vdf/{l,u,w} /tmp/m
>   mount -t overlay overlay /tmp/m -o
> lowerdir=/vdf/l,upperdir=/vdf/u,workdir=/vdf/w
>   umount /vdf
> 
> Yes users can lazy unmount, the filesystem itself on /dev/vdf is not actually
> unmounted, only the /vdf mount goes away from the namespace, but the use case
> without lazy unmount will still break.
> 
> Maybe its fine since distro/admin needs to opt-in for this change of behavior.

At current moment this options only affect on show options, but of course, we
can change patch, so that if both new features are turned off, we not hold
"struct path" reference. In this case behavior will fully as it was before proposed
changes.

> I have to wonder though, why did you add two different config/module
> options for this feature? Yes, its two different sub-functionalities, but
> which real user (not imaginary one) will really turn on just half the feature?

If user know that overmounts is not used on lowerdir/workdir/upperdir paths,
then it's not required to know mnt_id. Full path seems to be sufficient in this
scenario. It's not a critical for CRIU needs to have one or two options.

> While at it, you copy pasted the text:
>           For more information, see Documentation/filesystems/overlayfs.txt
> but there is no more information to be found.

As far as I know documentation patches must be send to another mailing list.
Of course I have plan to add information to overlayfs documentation about new feature.

> 
> > >
> > > I think you should describe the use case is more details.
> > > Is your goal to C/R any overlayfs mount that the process has open
> > > files on? visible to process
> > We wan't to dump a container, not a simple process, if the container
> > process has access to some resource CRIU needs to restore this resource.
> >
> > Imagine the process in container mounts it's own overlay inside
> > container, for instance to imulate write access to readonly mount or
> > just to implement some snapshots, don't know exact use case. And we want
> > to checkpoint/restore this container. (Currently CRIU only supports
> > overlay as external mount, e.g. for docker continers docker engine
> > pre-creates overlay for us and we just bind from it - it's a different
> > case.) If the in-container process creates the in-container mount we
> > need to recreate it on restore so that the in-container view of the
> > filesystem persists.
> >
> 
> Understood. but how do you *know* which mounts the container
> created and need to be migrated?
> Which loop devices the user has created?
> As opposed to the ones that docker engine re-created?
> It is the found from diff between mountinfo of process and host?

No, CRIU simply checkpoints *all* mounts in all mount namespaces
of process inside container, but if user (the one who calls criu,
e.g. container manager) want to use some mount from external mount
namespace then user must specify this mounts explicitly on restore
and we simply make bindmount (from this external mount) in
internal mount namespace.

> 
> > > For NFS export, we use the persistent descriptor {uuid;fhandle}
> > > (a.k.a. struct ovl_fh) to encode
> > > an underlying layer object.
> > >
> > > CRIU can look for an existing mount to a filesystem with uuid as restore stage
> > > (or even mount this filesystem) and use open_by_handle_at() to open a
> > > path to layer.
> >
> > On restore we can be on another physical node, so I doubt we have same
> > uuid's, sorry I don't fully understand here already.
> >
> 
> I see, so what about inotify/fanotify?
> fhandle and uuid can be looked up/resolved to mnt/path at "dump" time.
> The difference between mnt_id/uuid is who keeps the reference on the
> mount. If overlayfs provides uuid, then you rely on docker to keep the
> reference on the mount and use the reference-less uuid to find the
> mount that docker is holding for you.

Huh, seems very interesting! Thanks! I will need to dive into fhandle's
system to fully understand how it works.

> 
> > > After mounting overlay, that mount to underlying fs can even be discarded.
> > >
> > > And if this works for you, you don't have to export the layers ovl_fh in
> > > /proc/mounts, you can export them in numerous other ways.
> > > One way from the top of my head, getxattr on overlay root dir.
> > > "trusted.overlay" xattr is anyway a reserved prefix, so "trusted.overlay.layers"
> > > for example could work.
> >
> > Thanks xattr might be a good option, but still don't forget about (a)
> > and (b), users like to know all information about mount from
> > /proc/pid/mountinfo.
> >
> 
> Let's stick to your use cases requirements. If you have other use cases
> for this functionality lay them out explicitly.

Requirements is very simple, at "dump stage" we need to save all overlayfs mount options
sufficient to fully reconstruct overlayfs mount state on "restore stage". We already
have proof of concept implementation of Docker overlayfs mounts when docker is running in
OpenVZ container. In this case we fully dump all tree of mounts and all mount namespaces.
CRIU mounts restore procedure at first reconstruct mount tree in special separate subtrees
called "yards", then when all mounts is reconstructed we do "pivot_root" syscall. And
with overlayfs it was a problem, because we mounted overlayfs with lowerdir,workdir,upperdir
paths with mount namespace "yard" path prefix, and after restore in mount options user may see
that lowerdir,workdir,upperdir paths were changed... It's a problem. Also it makes second C/R
procedure is impossible, because after first C/R lowerdir,workdir,upperdir paths is invalidated
after pivot_root.

Example for Docker (after first C/R procedure):

options lowerdir=/tmp/.criu.mntns.owMo9C/9-0000000000//var/lib/docker/overlay2/l/4BLZ4WH6GZIVKJE5QF62QUUKVZ:/var/lib/docker/overlay2/l/7FYRGAXT35JMKTXCHDNCQO3HKT,upperdir=/tmp/.criu.mntns.owMo9C/9-0000000000//var/lib/docker/overlay2/30aa26fb5e5671fc0126f2fc0e84cc740ce6bf06ca6ad4ac877a3c60f5aceaf1/diff,workdir=/tmp/.criu.mntns.owMo9C/9-0000000000//var/lib/docker/overlay2/30aa26fb5e5671fc0126f2fc0e84cc740ce6bf06ca6ad4ac877a3c60f5aceaf1/work

/tmp/.criu.mntns.owMo9C/9-0000000000/ is a root yard for corresponding mount namespace. It's
service only temporary directory. After pivot_root this path is inaccessible and irrelevant.

To fix this problem 1st patch was prepared. To solve problem of C/Ring possible overmounts we
suggest 2nd patch with mnt_id showing.

> 
> I went to see what losetup does and I see that LOOP_SET_STATUS
> ioctl stores a path string that LOOP_GET_STATUS gets back in return.
> Does not seem C/R friendly either. Are you not handling loop devices?
> 
> It's strange because loop driver keeps an open backing file so
> LOOP_GET_STATUS could have returned the uptodate path.

At the moment we don't support loop-devices C/R. But yes, we may be will need to patch
ioctl(LOOP_GET_STATUS) for C/R needs.

> 
> Thanks,
> Amir.

-- 
Regards,
Alex.
