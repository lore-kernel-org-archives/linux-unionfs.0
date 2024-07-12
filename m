Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9873A1422D0
	for <linux-unionfs@vger.kernel.org>; Fri, 12 Jul 2024 11:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720784196; cv=none; b=PKJt3qhbqTflRj6tF7K1ogs7mtYp0tg/IPmjOAJqxQPVlSPTqEhlGlFSQMDKS3T1ytZhnGIH2XC0diHlRQ/e9/ME902eVkXm2LixHFWbacnimZIZ9XMF/p8gS6gcymiShIUAGsxhEJMU1+xLgqViXA84ZR5biJno1SU7U1s9518=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720784196; c=relaxed/simple;
	bh=Z4cPP3C2EqwZ0rWwksdZ3WyYbqXkcuTip9mXJC20f+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lq2pL42/P7qnj6rLZL2giL0EpsE8PdpoGgiYAlKlTvH/VoYiTcXFsSdLPYY/MRzn+EfYuL8ap9fuiOuslNHpfJIQwr+7rT7dmYUxMc/MXsIt0VsMRw//6RoExgAoXzJCjRTe+PyQjkWwsXR9r+1U0WKkBL7c0YME/dMxyEaBgF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com; spf=pass smtp.mailfrom=dneg.com; dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b=ZrXjj9d/; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dneg.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b="ZrXjj9d/"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-8101c661979so553297241.0
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Jul 2024 04:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1720784192; x=1721388992; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ZW9BtqkS6ny0C8idgMuK/0SvtXZVgNArFUykU8KM5g=;
        b=ZrXjj9d/TTvQWuFt/hA6XUc7nKXmU4cojqo1cxtLA4FhWPoDjnha7BQM2s1B/yv26p
         gZCvHo7UlKb7cYSusqytp4bfbDrLW5s2cS/RXB+UOgrg6TIC9aLJJN5uahipiCoAyUpA
         +jdOjJXy31f3RY/CBKLkvSdHmz0NoY9drr1SeQSD4X3zJYE2r1W4vPu7mRMWNi5rtkli
         SaUZrMpbHa+NOcH67a4wIT0kp41w/FQFa5nEFaIAzbI5YMf1sPQtOLz7O1PZCc/WwwwV
         2ZgNDFZP+FsbbytJrHZ9juZcvAgay3pcweLFnbHonCE4K9y4TQHi4NtxgiuG0aDa7Mo3
         +zMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720784192; x=1721388992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZW9BtqkS6ny0C8idgMuK/0SvtXZVgNArFUykU8KM5g=;
        b=TQl4XwseFGlK2ItY+jWQpnrAp+dc65Jjz1NDLa2dUM1alKTg5xdXvRg3byALjo99i3
         nO/GEttxejWHuXztd4CDE06w7+3wwQB6Q27IJq2RkVrEvwc94dbT/aHgpduoE8DzBWW+
         fcFmmhfGFPm77rDGAfUJrcwJCzmGHTWYKF8+BHdVxqYJGwKyXL/ySBSY0UnB51K+FqTS
         49GNn7b6yFK0ufvt6OQWEY+gvR97ajb2/Bz2JFWEbOMg0nojUwPTzvReV/sW1PkfUOhy
         aZKXuiTcQ4mxJLKHDLcppdIsJm1BG3rqrhKygU4XdclYZKeSeP6i5YJuB5IRuNxb4wL9
         /LAQ==
X-Gm-Message-State: AOJu0YwMgsWzs9jC/EO97v+WTf6QHUOR+4wkPc0/AAHVkpmtui6+QI4d
	4hJo38L2S5pXrtNxEUSkxIFVD+z63K9bPZ6PTwK3xIKE/KVpx0m+rkf0jSwqX2Nbd3rcYjN1JJ9
	07JrKj7rgS2d7TabvK9KtfMqZv+IUVQ8WeP1PxKpA2jzUlT4HZeayuA==
X-Google-Smtp-Source: AGHT+IGjPAZRkiy5Hq0F/lwln8mX37E57ocP7gLemkRni7Z8ifoQOl0HsBG7+gMTum/GzNEnAumoivhyJzSgaYWFKwE=
X-Received: by 2002:a05:6102:dd0:b0:48f:92e4:f295 with SMTP id
 ada2fe7eead31-4903213bcb0mr13440769137.18.1720784192286; Fri, 12 Jul 2024
 04:36:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
In-Reply-To: <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
From: Daire Byrne <daire@dneg.com>
Date: Fri, 12 Jul 2024 12:35:45 +0100
Message-ID: <CAPt2mGPWzGGZdGGRg2CEQw0QnHNSm7o7xpHow65R+iJ0BO5CMQ@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Amir,

Thanks for taking the time to write such an interesting and helpful
reply. I also feel a little less crazy knowing others like Mike have
similar workloads!

On Fri, 12 Jul 2024 at 00:30, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Jul 11, 2024 at 6:59=E2=80=AFPM Daire Byrne <daire@dneg.com> wrot=
e:
> >
> > Hi,
> >
> > Apologies for what I assume is another frequent (and long) "changes
> > outside of overlayfs" query, but I *think* I have a slightly unique
> > use case and so just wanted to ask some experts about the implications
> > of the "undefined behaviour" that the documentation (rightly) warns
> > against.
> >
> > Basically I have a read-only NFS filesystem with software releases
> > that are versioned such that no files are ever overwritten or changed.
> > New uniquely named directory trees and files are added from time to
> > time and older ones are cleaned up.
> >
>
> Sounds like a common use case that many people are interested in.
>
> > I was toying with the idea of putting a metadata only overlay on top
> > of this NFS filesystem (which can change underneath but only with new
> > and uniquely named directories and files), and then using a userspace
> > metadata copy-up to "localise" directories such that all lookups hit
> > the overlay, but file data is still served from the lower NFS server.
> > The file data in the upper layer and lower layer never actually
> > diverge and so the upper layer is more of a one time permanent
> > (metadata) "cache" of the lower NFS layer.
> >
> > So something like "chown bob -R -h /blah/thing/UIIDA/versionXX/lib" to
> > copy-up metadata only. No subsequent changes will ever be made to
> > /blah/thing/UIIDA/versionXX/lib on the lower filesystem (other than it
> > being deleted). Now, at some point, a new directory
> > /blah/thing/UIIDB/versionYY/lib might appear on the lower NFS
> > filesystem that has not yet got any upper directory files other than
> > perhaps sharing part of the directory path - /blah/thing.
> >
> > Now this *seems* to work in very basic testing and I have also read
> > the previous related discussion and patch here:
> >
> > https://lore.kernel.org/all/CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=3D8H1f7+=
3v3zysW9qA@mail.gmail.com
> >
> > My first question is how bad can the "undefined behaviour" be in this
> > kind of setup?
>
> The behavior is "undefined" because nobody tried to define it,
> document it and test it.
> I don't think it would be that "bad", but it will be unpredictable
> and is not very nice for a software product.
>
> One of the current problems is that overlayfs uses readdir cache
> the readdir cache is not auto invalidated when lower dir changes
> so whether or not new subdirs are observed in overlay depends
> on whether the merged overlay directory is kept in cache or not.

Yea, I think this is the biggest problem. We would still want to see
new software releases in a timely manner on the clients as they appear
on the remote filesystem and it is likely that those will appear in a
directory in part of the parent tree that has already been recently
accessed via the overlay (/blah/thing/new-UUID appears where
/blah/thing/old-UUID was recently accessed).

Periodically dropping caches seems like a rather brute force way
re-read the backing NFS filesystem! I was hoping there might be some
way to tie the NFS (v3) client's desire to periodicaily to invalidate
entries (attribute cache) or even force overlayfs to not use readdir
caching at all and do the dir lookups everytime. I know aufs has some
mechanisms around this (UDBA?) but even then it relies on changes
being made on the local client rather than some other client of a
remote NFS share.

But I just did this as a test and now I've confused myself as I
thought this didn't work when I tried it before:

mount -o vers=3D4.2 serverA:/mnt/data /mnt/data
mount -t overlay overlay -o
metacopy=3Don,rw,lowerdir=3D/mnt/data,upperdir=3D/var/cache/overlay/upperdi=
r,workdir=3D/var/cache/overlay/workdir/test
/mnt/overlay
chown bob /mnt/overlay/dir1/dir2
touch /mnt/overlay/dir1/dir2/file1

Now if I mount serverA:/data on another completely seperate NFS client
and create dirs or files in serverA:/mnt/data/dir1/dir2, I can also
see them appearing (ls -l) on the client with the overlay. I was sure
that wasn't working before because of the readdir cache that overlayfs
uses...

So I can create dirs on the NFS share within directories that the
overlay has already recently "accessed"? Or maybe that's just not
guarenteed behaviour and I'm just lucky? NFS server is EL9 and client
was EL8 if that makes any odds.

> > Any files that get copied up to the upper layer are
> > guaranteed to never change in the lower NFS filesystem (by it's
> > design), but new directories and files that have not yet been copied
> > up, can randomly appear over time. Deletions are not so important
> > because if it has been deleted in the lower level, then the upper
> > level copy failing has similar results (but we should cleanup the
> > upper layer too).
> >
> > If it's possible to get over this first difficult hurdle, then I have
> > another extra bit of complexity to throw on top - now manually make an
> > entire directory tree (of metdata) that we have recursively copied up
> > "opaque" in the upper layer (currently needs to be done outside of
> > overlayfs). Over time or dropping of caches, I have found that this
> > (seamlessly?) takes effect for new lookups.
> >
> > I also noticed that in the current implementation, this "opaque"
> > transition actual breaks access to the file because the metadata
> > copy-up sets "trusted.overlay.metacopy" but does not currently add an
> > explicit "trusted.overlay.redirect" to the correspnding lower layer
> > file. But if it did (or we do it manually with setfattr), then it is
> > possible to have an upper level directory that is opaque, contains
> > file metadata only and redirects to the data to the real files on the
> > lower NFS filesystem.
> >
> > Why the hell would you want to do this? Well, for the case where you
> > are distributing software to many machines, having it on a shared NFS
> > filesystem is convenient and reasonably atomic. But when you have
> > sofware with many many PATHs (LD_LIBRARY, PYTHON, etc), you can create
> > some pretty impressive negative lookups across all those NFS hosted
> > directories that can overhelm a single NFS storage server at scale. By
> > "caching" or localising the entire PATH directory metadata locally on
> > each host, we can serve those negative lookups from local opaque
> > directories without traversing the network.
> >
> > I think this is a common enough software distribution problem in large
> > systems and there are already many different solutions to work around
> > it. Most involve localising the software on demand from a central
> > repository.
> >
> > Well, I just wondered if it could ever be done using an overlay in the
> > way I describe? But at the moment, it has to deal with a sporaidcally
> > changing lower filesystem and a manually hand crafted upper
> > filesystem. While I think this might all work fine if the filesystems
> > can be mounted and unmounted between software runs, it would be even
> > better if it could safely be done "online".
>
> How about this for a workaround:
>
> From your explanations, I understand that you are expecting only specific
> directories to grow (e.g.  /blah/thing/ and /blah/thing/UIID*/), while ot=
her
> directories are immutable (e.g. /blah/thing/UIIDA/versionXX/) is that cor=
rect?

Yes, pretty much. Maybe the top 3 levels of directories can grow new
entries, but once you get to the third or fourth level and all the way
to the end of the trees, all those files and dirs are going to be
immutable - they will only ever be deleted.

> Can you monitor those directories mtime on NFS using a dedicated service?

That might be feasible, but I think there might be a lot of
directories to check... 3000 on the root level, x 10 average on the
second level and then 2000+ clients all checking mtime... Our software
NFS volume is currently 10 million inodes used.

> If you can then there might be a workable solution to your problems:
>
> - Instead of chown -R to copy up all dirs and metacopy all files
> create an identical opaque directory hierarchy and *move* all the
> files into the opaque directory hierarchy.
> - When the service detects a new subdir on NFS, add the subdir to the
> opaque directory hierarchy and *move* the files from the merged subdir
> to the opaque subdir of the same name.
>
> The result is that:
> - all the directories in the opaque hierarchy are opaque as you wanted
> - all the files have metacopy and absolute redirect
> - if you take care no to expose the merged hierarchy to users (only to
>   the service), then the overlayfs merged hierarchy will not have any
>   readdir caches (service only iterates on NFS directly)
> - if service only ever accesses the merged hierarchy as the move source
>   then there should be no negative lookup caches in the merged hierarchy
> - all this happens legitimately while overlayfs is mounted, without
>   having to manually tweak trusted.overlay xattrs and drop caches
>
> Assuming that I didn't miss anything and this can work for you,
> how can we document it to make the behavior "defined"?

Okay, bear with me while I digest this and do some more tests to see
if I fully understand what you are suggesting. But I *think* you are
saying that I would eventually have a metacopy of *every* directory
tree and file from the lower NFS filesystem and only that would be
accessed by processes to run the software?

I should clarify that I was thinking of this as more of an optional
slow moving cache. In other words, if I never create an upper opaque
directory and contents, I still want to serve the all data and paths
as per normal from the lower NFS filesystem. The access should always
"fall through" to the NFS software volume in the absence of any upper
layer modifications or copies.

Then I would have a service watching for access to lib/module type
dirs only (systemtap or bpf) and "promote" frequently hit (maybe even
just noent heavy) directories to opaque metadata only copies on the
upper (local filesystem) layer. I reckon this would only be a small
fraction of the total 10 million inodes.

So it's different to the data only layer or a composefs style
construct where the only access is via a pre-determined complete
metadata tree. Instead, I am trying to dynamically detect workloads
and only create select local opaque copies such that at some point in
the near future, access will be accelerated by the local copy. It
doesn't even matter if it takes many hours before the upper layer
opaque metadata cache starts to be used (i.e. after cache timeout or
eviction) - it is still useful that the cache will then work for many
weeks hence and after umounts and reboots.

I would rather not pre-create complete metadata trees (ala composefs)
as there are just too many files and directories and much of it
probably never gets accessed. I would much prefer to be able to do it
on demand as a service for accelerating small parts of the entire tree
(i.e. lib/module directories).

> My thinking is:
>
> "Changes to the underlying filesystems while part of a mounted overlay
> filesystem are not allowed.  If the underlying filesystem is changed,
> the behavior of the overlay is undefined, though it will not result in
> a crash or deadlock.
>
> One exception to this rule is changes to underlying filesystem objects
> that were not accessed by a overlayfs prior to the change.
> In other words, once accessed from a mounted overlay filesystem,
> changes to the underlying filesystem objects are not allowed."
>
> But this claim needs to be proved and tested (write tests),
> before the documentation defines this behavior.
> I am not even sure if the claim is correct.
>
> One more thing that could help said service is if overlayfs
> supported a hybrid mode of redirect_dir=3Dfollow,metacopy=3Don,
> where redirect is enabled for regular files for metacopy, but NOT
> enabled for directories (which was redirect_dir original use case).
>
> This way, the service could run the command line:
> $ mv /ovl/blah/thing /ovl/local
> then "mv" will get EXDEV for moving directories and will create
> opaque directories in their place and it will recursively move all
> the files to the opaque directories.

Okay, I think I see what you are getting at but I need to test the
patch to make sure :)

I mean I also tested hand crafting the metadata upper layer outside of
the overlay while it was still mounted too. To replicate what overlay
does natively, it involved running truncate, chmod, chown, touch using
the reference flag to the origin file on NFS, and then finally setting
trusted.overlay.opaque and trusted.overlay.redirect.

My rationale here is that after some time in the future the overlay
will drop it's cache of the upper layer contents and re-read my hand
crafted version instead. I naively figured that for (read-only) open
files, the file is the same NFS destination, but open dirs at this
time might cause issues.

This is defintely extra "undefined" behaviour and so I thought it
would be much safer to be able to do it via the overlay itself (like
chown and/or the mv you are suggesting).

I have also not completely given up on the idea of making these
changes offline and using autofs to manage remounting with a
hand-crafted overlay. But with so many top level directories, this can
become quite unwieldy with many active mounts of the same remote NFS
share. I'm also not sure that some of those dirs are likely to ever
timeout and get remounted by autofs - they are constantly in use hence
why being able to do it live to a mounted filesystem would be better.

> Actually, current code does not even check for redirect_dir=3Don
> (i.e. in ovl_can_move()) before setting redirect xattr on regul
> metacopy files.
>
> So as far as I can tell, the following UNTESTED patch might
> be acceptable, so you can try it out if you like if you think this
> will help you implement to suggestions above:
>
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -824,15 +824,9 @@ int ovl_fs_params_verify(const struct ovl_fs_context=
 *ctx,
>                 config->metacopy =3D true;
>         }
>
> -       /*
> -        * This is to make the logic below simpler.  It doesn't make any =
other
> -        * difference, since redirect_dir=3Don is only used for upper.
> -        */
> -       if (!config->upperdir && config->redirect_mode =3D=3D OVL_REDIREC=
T_FOLLOW)
> -               config->redirect_mode =3D OVL_REDIRECT_ON;
> -
>         /* Resolve verity -> metacopy -> redirect_dir dependency */
> -       if (config->metacopy && config->redirect_mode !=3D OVL_REDIRECT_O=
N) {
> +       if (config->metacopy && config->redirect_mode !=3D OVL_REDIRECT_O=
N &&
> +                               config->redirect_mode !=3D OVL_REDIRECT_F=
OLLOW) {
>                 if (set.metacopy && set.redirect) {
>                         pr_err("conflicting options:
> metacopy=3Don,redirect_dir=3D%s\n",
>                                ovl_redirect_mode(config));
> --
>
> Apologies in advance if this idea is flawed.

No, thank you for even entertaining my idea. I'm not sure it's a good
one, but at least I now know it's not completely crazy!

Daire
