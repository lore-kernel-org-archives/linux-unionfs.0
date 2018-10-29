Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CAOQ4uxjSB_7cnu71EvZ+uOTgfMKsbNxQ+Fd8cVjfFhMo=EiMOg@mail.gmail.com>
 <20181026192039.GA29504@redhat.com> <CAJfpegswL4mxfRigx0jDtTwta0Kdpv9Lh3cGuP+r6dvP7s_iyQ@mail.gmail.com>
 <20181026195215.GB29504@redhat.com> <20181026200739.GC29504@redhat.com>
 <CAJfpegtCa5+_wC11TKC8s=R3-vaONe5WxHm=oHzq1BG4kPJanQ@mail.gmail.com>
 <CAOQ4uxhOJye--zmEB4=Xuwnq4pMKGtbKq4b_0LZZLFG90BgFwQ@mail.gmail.com>
 <20181026212234.GD29504@redhat.com> <20181026213311.GA6155@redhat.com>
 <CAOQ4uxhf-aabMgrQt2_a5bqXUuuSi_QYst38tMJ0wV0xZzSc4Q@mail.gmail.com>
 <20181029191610.GC24630@redhat.com> <CAOQ4uxhhiYE-2E_ZAMj16aNnsk+QE1Wxvv+vkuOuhDXCg3Cp5w@mail.gmail.com>
In-Reply-To: <CAOQ4uxhhiYE-2E_ZAMj16aNnsk+QE1Wxvv+vkuOuhDXCg3Cp5w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 29 Oct 2018 23:32:34 +0200
Message-ID: <CAOQ4uxhSnvznJ3VY1ovGy3yKbMi1mOZ_b-qjt1crXrzsxY81YQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: disable new features for deprecated upper fs
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

[adding back CC list, which I accidentally dropped a few emails back..]

On Mon, Oct 29, 2018 at 10:18 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Oct 29, 2018 at 9:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Sat, Oct 27, 2018 at 06:50:42AM +0300, Amir Goldstein wrote:
> > [..]
> > > Rule of thumb: if you have to write so much to explain a feature to
> > > yourself it won't fly nicely in documentation and users will not understand
> > > how it works.
> > >
> > > The special casing of metacopy is really bad is that aspect.
> >
> > Hi Amir,
> >
> > I think I am not trying to special case metacopy. I am trying to think
> > a good reasonable behavior for any new parameter introduced.
> >
>
> OK, but having different behavior for metacopy and for nfs_export
> just because they were not introduced at the same time is inconsistent.
>
> > >
> > > Often when we need to think too much on an issue is because we resist to
> > > take the simple solution that we don't like.
> >
> > What do other filesystems do? If user asked for a certain feature and
> > passed that in option in mount option, disabling that silently (with a
> > warning message in logs), feels odd to me.
> >
>
> There is no consistent behavior in that regard AFAIK.
> I believe that is what happens with -o dax on xfs.
> That is what _require_scratch_dax() says.
>
> > >
> > > The simple solution is no implicit behavior everything user gets is
> > > explicitly configurable and explicitly displayed in /proc/mounts.
> > >
> > > Your analysis misses a very important aspect of /proc/mounts reflecting the
> > > nature of this mount and the fact that user can replay the options in
> > > /proc/mounts to get the same resulting mount in the future. It may not
> > > always be the case with filesystems, but some users will be surprised if it
> > > doesn't work.
> >
> > Hmm.., not sure about that. Where did I change the nature of /proc/mounts.
> > If we are enforcing an option and return error, then this point is moot.
> > If we are automatically disabling a feature, then its no different than
> > what we are doing now.
> >
> > Are you saying that things are currently broken and my proposal did not
> > address that? Or things are currently working and my proposal broke
> > that.
> >
>
> I am not really sure. Just let's try to keep that in mind -
> if we replay mount options from /proc/mounts they are expected
> to create a mount with same options at least for the same kernel/module
> config. I guess nothing you proposed breaks that.
>
> > >
> > > So the simple to implement and to document is either an explicit mount
> > > option determine the enforcement behavior for all options or new values to
> > > existing mount options that are different from the value of default
> > > enabled. For example:
> > >
> > > metacopy=require
> >
> > So your idea is that for every option we have two variant. One which
> > can be disabled silently and one which can't be disabled and error will
> > be returned.
> >
> > So metacopy=require means metacopy=on or metacopy=off. Somebody might
> > want to enforce metacopy=off (in case kernel enables it by default).
>
> I did not consider require-off.
> I did propose an alternative solution: -o incompat=[error|disable]
> which applies to *all* options provided in mount command - not
> only to metacopy, because it happens to be easy enough to change
> its behavior at this time.
>
> >
> > But how is much different then my idea. I am saying instead of having
> > two variants, make sure anything passed as mount option, is always
> > enforced.
> >
>
> I think your idea is good... if we only implemented it from the first feature
> (redirect_dir) it would have been awesome.
>
> > >
> > > It's so simple to understand, you don't even need to document it.
> >
> > Well, many of the rules I have mentioned are implicit with
> > metacopy=require. Some rules it does not address like automatically
> > enabling a feature (redirect_dir=on).
> >
>
> I agree that turning redirect_dir on makes sense, however
> redirect_dir=no_follow,metacopy=on should not work.
> We need to somehow make order in all the mess, but sadly, I just don't see it
> happening without a boring new mount/module/Kconfig option.
> I just don't see how we can sanely document all the behavior otherwise.
> I'll be happy to be proven wrong.
>
> > >
> > > It's so simple to implement, you don't even need to change all place that
> > > refer to config.metacopy as boolean when you turn it into an enum.
> >
> > I think at high level there are only two rules different.
> >
> > - I am saying anything passed as mount option is enfroced and returned
> >   error if it can't be enforced.
> >
> > - You are saying that anyting passed as mount option is overridable by
> >   default and create a new option if user wants to change that behavior.
> >
> > I think rest of the rules will more or less apply. Just that these
> > are not documented anywhere.
> >
> > Anyway, I am fine with any reasonable proposal. Just want to make sure
> > Dan Walsh and other users of metacopy are not surprised. Just think of
> > this.
> >
> > - A user passes in metacopy=on and gets -EINVAL (because kernel is old
> >   and does not support the feature).
> >
> > - A new kernel supports metacopy feature and user passes in metacopy=on
> >   and does not get any error, but still metacopy feature is not enabled.
> >
> > I think that should be fixed. A kernel not supporting the feature returns
> > an error if feature can't be enabled but a kernel supporting the feature
> > does not return an error, despite the fact that feature could not be
> > enabled.
> >
>
> The problem is real all right and we need to solve it, yet you did not provide
> any argument against an explicit new config option to opt-in for new sane
> behavior. I don't like it, but I don't see how we can avoid it.
>

Adding another terrible idea to add to the pile of non perfect solutions.
I never liked the 'feature=[on|off]' standard, which is different from the more
common standard of '[feature|nofeature]' mount options.

What if we interpreted mount options 'feature=[on|off]' as advisory and
mount options '[feature|nofeature]' as mandatory?

The mandatory semantics could mark the start of the mkfs.overlay era
(a.k.a overlayfs on-disk format v2).
Meaning that you can only mount with mandatory 'metacopy' if either:
- upperdir AND workdir are empty
OR
- layers where created with mkfs.overlay with mandatory 'metacopy'
OR
- overlay was always mounted in the past with mandatory 'metacopy'
OR
- fsck.overlay is used to check layers and add mandatory 'metacopy'

Zhangyi,

Do you have plans to post another version of overlayfs feature set
patches for kernel/overlayfs-progs anytime soon?

Thanks,
Amir.
