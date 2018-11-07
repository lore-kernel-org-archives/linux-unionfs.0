Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181101004813.31349-1-amir73il@gmail.com> <20181101004813.31349-2-amir73il@gmail.com>
 <20181101130322.GA15140@redhat.com> <CAJfpegsbzNR6hKVrm5+A19D2MqEQat=ytR1TUax-+O2tEb7WFA@mail.gmail.com>
 <CAJfpegsLjG3n7WhzH4YHc-aGDMR-jHOydMmMswn=d6TfPtPRpQ@mail.gmail.com>
 <CAOQ4uxg42nW4V5RdbLq9w2Vk1zUBwGBpxSREgKnm7s46da0RKg@mail.gmail.com>
 <CAJfpegsDhAdMCxqL4GBu9PxvDy2=q+syvoyfR8=k-77h=b_Hag@mail.gmail.com>
 <CAOQ4uxjt3USJM59i_8b2-uuyppyRmJ9t0=LLbqVSKdK4vm77NQ@mail.gmail.com> <CAJfpegvhsCgRYBbSBi2HzwMF1ZDuMvoxt0u14Zdm2nQchpUN1w@mail.gmail.com>
In-Reply-To: <CAJfpegvhsCgRYBbSBi2HzwMF1ZDuMvoxt0u14Zdm2nQchpUN1w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Nov 2018 13:59:05 +0200
Message-ID: <CAOQ4uxh+yP2337Qd-WroTU7kPRn=7i__AjPLyEJs07DRxME5qw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: return error on mount if metacopy cannot be enabled
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Nov 7, 2018 at 1:26 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Nov 5, 2018 at 1:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> >> > Are you still going to redo the "strict" series?
> >> > With metacopy out of the picture, I can just reorder the patches
> >> > and drop the metacopy=on mentions.
> >> > Let me know if you want me to do that.
> >>
> >> I'll post what I have next week (done for this week).
> >>
> >
> > FWIW, I forgot we need to enforce ovl_inuse_lock (upperdir/workdir)
> > under the "strict" rules.
> > We relaxed ovl_inuse_lock() for index=off because of docker mount
> > leaks, but if we have no backward compat restrictions, we should
> > enforce it regardless of index=on.
> >
> >> >
> >> >> Anyway, pushed a metacopy fix to overlayfs-next, that I'm pretty happy with.
> >> >>
> >> >
> >> > Me too.
> >> > We should do the same for nfs_export=on implies index=on.
> >> > There are probably more users that just want nfs_export=on
> >> > than users that know what index=on even means.
> >> > Let me know if you want me to do that.
> >>
> >> Yeah, probably makes sense.
> >>
> >> And there's the annoying fact that nfs_export can't be enabled if
> >> metacopy is on by default...
> >>
> >> Not sure how much backward compat headache would involve changing these.
> >>
> >
> > Not sure I am seeing the problem.
> >
> > Case #1:
> > INDEX=N
> > NFS_EXPORT=N
> > METACOPY=N
> > nfs_export=on
> >
> > This will change behavior from "fallback to nfs_export=off" to
> > "implicit enabled of index=on" also implying ovl_inuse_lock().
> > But we don't have any docker users setting nfs_export=on
> > (What for? it doesn't work. docker sets index=off).
> >
> > Case #2:
> > INDEX=N
> > NFS_EXPORT=N
> > METACOPY=Y
> > nfs_export=on
> >
> > Disables metacopy and enables index.
> > Which problems will that cause (??)
> >
> > I have no idea how "strict" affects the cases above (??)
> > Kconfig is rather simple because inter dependencies are already
> > encoded.
> > mount options should always win over Kconfig.
> > module param inter dependencies - I have no idea.
>
> After looking at this issue some more, I've pretty much convinced
> myself that "strict" should not have any affect on inter-option
> dependencies.  The "strict" option is good for things like xattr and
> inuse_lock, etc.
>

OK. (including RENAME_WHITEOUT and d_type)

But what about being "strict" about the need for underlying fs
to support file handles for index and nfs_export?

Implementation-wise that could be solved by storing the information
about which options have been set in mount in a bitmap in ovl_config.


> And if manage to resolve the inter-option dependencies like the
> metacopy/redirect_dir one, then we're good, so let's see:
>
> metacopy implies redirect_dir
> nfs_export implies index
> if (!upper)
>     nfs_export implies !redirect_dir
> metacopy implies !nfs_export
>
> Like with metacopy/redirect_dir, conflicting mount options would be
> rejected, only the default would be overridden by the implication.
>

OK.

The "thorny part" is that with your implementation of
metacopy/redirect_dir all the decisions can be made at the end of options
parsing. With nfs_export, mount option can turn it on and then no file handle
support will turn it off.
If at option parsing time we let nfs_export imply !redirect_dir, we are
left with !redirect_dir and !nfs_export.

If we let "mount option is stronger than defaults" behavior depend on
"strict=on" than this is not a problem, because nfs_export/index
won't be turned off by no file handles and therefore it is safe to resolve
all interdependencies at the end of mount option parsing.

> Not sure about the direction of the nfs_export/metacopy implication,
> it just as well could be the other way round and since metacopy is
> new, we probably can still change behavior if backported to stable.
> Note: changing the direction only changes the behavior if neither of
> the options is given, so that's the "resolve module param
> interdependencies" case.
>

and Kconfig will choose metacopy if both are set to Y...

I think current direction makes sense. In the system/distro level it makes
sense for the default to be efficient in copy up. In the fs instance level,
user/application can opt-in for NFS export feature in favor of efficient
copy up.

Thanks,
Amir.
