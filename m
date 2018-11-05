Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181101004813.31349-1-amir73il@gmail.com> <20181101004813.31349-2-amir73il@gmail.com>
 <20181101130322.GA15140@redhat.com> <CAJfpegsbzNR6hKVrm5+A19D2MqEQat=ytR1TUax-+O2tEb7WFA@mail.gmail.com>
 <CAJfpegsLjG3n7WhzH4YHc-aGDMR-jHOydMmMswn=d6TfPtPRpQ@mail.gmail.com>
 <CAOQ4uxg42nW4V5RdbLq9w2Vk1zUBwGBpxSREgKnm7s46da0RKg@mail.gmail.com> <CAJfpegsDhAdMCxqL4GBu9PxvDy2=q+syvoyfR8=k-77h=b_Hag@mail.gmail.com>
In-Reply-To: <CAJfpegsDhAdMCxqL4GBu9PxvDy2=q+syvoyfR8=k-77h=b_Hag@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 5 Nov 2018 14:57:15 +0200
Message-ID: <CAOQ4uxjt3USJM59i_8b2-uuyppyRmJ9t0=LLbqVSKdK4vm77NQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: return error on mount if metacopy cannot be enabled
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

> > Are you still going to redo the "strict" series?
> > With metacopy out of the picture, I can just reorder the patches
> > and drop the metacopy=on mentions.
> > Let me know if you want me to do that.
>
> I'll post what I have next week (done for this week).
>

FWIW, I forgot we need to enforce ovl_inuse_lock (upperdir/workdir)
under the "strict" rules.
We relaxed ovl_inuse_lock() for index=off because of docker mount
leaks, but if we have no backward compat restrictions, we should
enforce it regardless of index=on.

> >
> >> Anyway, pushed a metacopy fix to overlayfs-next, that I'm pretty happy with.
> >>
> >
> > Me too.
> > We should do the same for nfs_export=on implies index=on.
> > There are probably more users that just want nfs_export=on
> > than users that know what index=on even means.
> > Let me know if you want me to do that.
>
> Yeah, probably makes sense.
>
> And there's the annoying fact that nfs_export can't be enabled if
> metacopy is on by default...
>
> Not sure how much backward compat headache would involve changing these.
>

Not sure I am seeing the problem.

Case #1:
INDEX=N
NFS_EXPORT=N
METACOPY=N
nfs_export=on

This will change behavior from "fallback to nfs_export=off" to
"implicit enabled of index=on" also implying ovl_inuse_lock().
But we don't have any docker users setting nfs_export=on
(What for? it doesn't work. docker sets index=off).

Case #2:
INDEX=N
NFS_EXPORT=N
METACOPY=Y
nfs_export=on

Disables metacopy and enables index.
Which problems will that cause (??)

I have no idea how "strict" affects the cases above (??)
Kconfig is rather simple because inter dependencies are already
encoded.
mount options should always win over Kconfig.
module param inter dependencies - I have no idea.

Thanks,
Amir.
