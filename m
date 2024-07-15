Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FA2186E5A
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 09:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721037570; cv=none; b=KV89u0P43ahZbjYk9mX/FlKfPkb97YJaxtYdS9+GJJk6FgcuSWXeMX2B0lovld1LlsAv6sN2N3GyxodisIDomS4DP2zz94x55+joIhb0Bafp3B9b68XmF+QlOdCeeb9Gl/C4TP6KKMYc7n3mOgYCdlib/ZLhfHC61ln1daPXVvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721037570; c=relaxed/simple;
	bh=Qv1pzKkW7nq2F5L7ZIBTD/f7XtGN0AqmBd2cjv69NeU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WN0Czmv7HY7uTXmkB4GqLuAh2N4ZABxSGjYcWSnp5xmCxlQy1KqOv1XnAfsY32yG79WLBkBHxxKwDpW1kzIHUZkNYKXLbjAQz2tsEUvE+paBZYmaHtEIW3tYe/CGDKpVsJA2cKJT/7T9JxkUBpQXgUkangA8OjtsVRgEPXWuuaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com; spf=pass smtp.mailfrom=dneg.com; dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b=KCZETl37; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dneg.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b="KCZETl37"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52ea929ea56so7545149e87.0
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 02:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1721037566; x=1721642366; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDC3f3sRTUAEyH8nBHMwJVdkty/FywyaK+o4LnmDvZo=;
        b=KCZETl37qcpSkdOTtlkpfDRnOBR9ajErARlJqFiyXx9UvPtC8aZpuC5bKDqaTc+E4q
         ESdEI6fC13ZDTkVC7Er5z4s6EryJokxB8FQeOdElTYg9LupY+JQK/P72EGT0BNp1TSWz
         0X6/HuZ4lpRTUOmeJYdnXD6Mr+AHR/Itj7FsQoxE98wdGHaEVwq+RcQQMrIORDuQke14
         Hy5LYxz0GJ6onfsySyJ2uEuHljBapCkFZHYowzh+g21shJXP4DeWaFl6SwWDyC+HAUKb
         ARxS4+NQHn6laV4OuJM51aExGVwBtoSMLLvz5udDJm33S36SWI1lXXICPz8WlW1Prj/Y
         RBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721037566; x=1721642366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDC3f3sRTUAEyH8nBHMwJVdkty/FywyaK+o4LnmDvZo=;
        b=FRwBNZTcK1AM9uZyYfbwCMtsnu6D5qU1Oz7ZWt46jCfDLjz0wcsyvgaEtLw1Wc22xd
         LDBiKvMCbS6/kSaII6YpPjLm1TFQ8x1SZYXZfCOxA/Y0diBHwU/i65CE7VGF/g6vdCP8
         +XbZXc9m4DwgJyOiL9phMBEZSLYo2dFANUnfs4Wl7SFpXeuKrUmOqP2e0Ul1b9fnV0Yn
         kA3es8Ov+96KwgTTZ27obSwt/zBPy3yXLUI+vdCu2Gwv8si3cjCAAg4Nc1TilNJwTMBB
         3hWK/T+nkEVgyhfE+Q3cJV0zJ1m/5QMisCfeVosOiOqyoN2i9+f/9MBeJUx+WbNYHprI
         CjEQ==
X-Gm-Message-State: AOJu0YyhmVzJcXo8CF2Na+9nC2F2zNmlrKancVRrpw964Y70PA7WYIZb
	XU37ipffA12vKe6woktcyH4G0BmL43jXQAXc9zn48jCrcp3wGDxT1I5KKQh0rWkVVmBnXFP6Tmb
	cfTcVsVResHhZQu0ud67/D/8GV6GC3KIp4mm6NA==
X-Google-Smtp-Source: AGHT+IHYUwVITmXBnqX0ivFDbf7T7J7bEUoM2aucE61eZvmLdYy48F9br51pb0P2OQmegZxH0I6nSQoNhaclJCK4ADI=
X-Received: by 2002:a05:6512:6c3:b0:52c:e10b:cb33 with SMTP id
 2adb3069b0e04-52eb99d2722mr16382887e87.50.1721037565355; Mon, 15 Jul 2024
 02:59:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
 <CAPt2mGPWzGGZdGGRg2CEQw0QnHNSm7o7xpHow65R+iJ0BO5CMQ@mail.gmail.com> <CAOQ4uxg16b7SJrsN=5kvE0QSD94-VoHiWTCvGVbGEcaadfVmeA@mail.gmail.com>
In-Reply-To: <CAOQ4uxg16b7SJrsN=5kvE0QSD94-VoHiWTCvGVbGEcaadfVmeA@mail.gmail.com>
From: Daire Byrne <daire@dneg.com>
Date: Mon, 15 Jul 2024 10:58:48 +0100
Message-ID: <CAPt2mGOkxUE7t22SrcW6hHW+OaccNuB8Xem-hVAv-aiyteiXqw@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Jul 2024 at 21:47, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Jul 12, 2024 at 2:36=E2=80=AFPM Daire Byrne <daire@dneg.com> wrot=
e:
> >
> > Amir,
> >
> > Thanks for taking the time to write such an interesting and helpful
> > reply. I also feel a little less crazy knowing others like Mike have
> > similar workloads!
> >
> > On Fri, 12 Jul 2024 at 00:30, Amir Goldstein <amir73il@gmail.com> wrote=
:
> > >
> > > On Thu, Jul 11, 2024 at 6:59=E2=80=AFPM Daire Byrne <daire@dneg.com> =
wrote:
> > > >
> > > > Hi,
> > > >
> > > > Apologies for what I assume is another frequent (and long) "changes
> > > > outside of overlayfs" query, but I *think* I have a slightly unique
> > > > use case and so just wanted to ask some experts about the implicati=
ons
> > > > of the "undefined behaviour" that the documentation (rightly) warns
> > > > against.
> > > >
> > > > Basically I have a read-only NFS filesystem with software releases
> > > > that are versioned such that no files are ever overwritten or chang=
ed.
> > > > New uniquely named directory trees and files are added from time to
> > > > time and older ones are cleaned up.
> > > >
> > >
> > > Sounds like a common use case that many people are interested in.
> > >
> > > > I was toying with the idea of putting a metadata only overlay on to=
p
> > > > of this NFS filesystem (which can change underneath but only with n=
ew
> > > > and uniquely named directories and files), and then using a userspa=
ce
> > > > metadata copy-up to "localise" directories such that all lookups hi=
t
> > > > the overlay, but file data is still served from the lower NFS serve=
r.
> > > > The file data in the upper layer and lower layer never actually
> > > > diverge and so the upper layer is more of a one time permanent
> > > > (metadata) "cache" of the lower NFS layer.
> > > >
> > > > So something like "chown bob -R -h /blah/thing/UIIDA/versionXX/lib"=
 to
> > > > copy-up metadata only. No subsequent changes will ever be made to
> > > > /blah/thing/UIIDA/versionXX/lib on the lower filesystem (other than=
 it
> > > > being deleted). Now, at some point, a new directory
> > > > /blah/thing/UIIDB/versionYY/lib might appear on the lower NFS
> > > > filesystem that has not yet got any upper directory files other tha=
n
> > > > perhaps sharing part of the directory path - /blah/thing.
> > > >
> > > > Now this *seems* to work in very basic testing and I have also read
> > > > the previous related discussion and patch here:
> > > >
> > > > https://lore.kernel.org/all/CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=3D8H=
1f7+3v3zysW9qA@mail.gmail.com
> > > >
> > > > My first question is how bad can the "undefined behaviour" be in th=
is
> > > > kind of setup?
> > >
> > > The behavior is "undefined" because nobody tried to define it,
> > > document it and test it.
> > > I don't think it would be that "bad", but it will be unpredictable
> > > and is not very nice for a software product.
> > >
> > > One of the current problems is that overlayfs uses readdir cache
> > > the readdir cache is not auto invalidated when lower dir changes
> > > so whether or not new subdirs are observed in overlay depends
> > > on whether the merged overlay directory is kept in cache or not.
> >
> > Yea, I think this is the biggest problem. We would still want to see
> > new software releases in a timely manner on the clients as they appear
> > on the remote filesystem and it is likely that those will appear in a
> > directory in part of the parent tree that has already been recently
> > accessed via the overlay (/blah/thing/new-UUID appears where
> > /blah/thing/old-UUID was recently accessed).
> >
> > Periodically dropping caches seems like a rather brute force way
> > re-read the backing NFS filesystem! I was hoping there might be some
> > way to tie the NFS (v3) client's desire to periodicaily to invalidate
> > entries (attribute cache)
>
> NFS can revalidate dir mtime of lower dir, but overlayfs does not
> consider it at all for readdir cache validity.
>
> > or even force overlayfs to not use readdir
> > caching at all and do the dir lookups everytime. I know aufs has some
> > mechanisms around this (UDBA?) but even then it relies on changes
> > being made on the local client rather than some other client of a
> > remote NFS share.
> >
>
> There are surely ways to do this - ovl readdir cache could record the
> mtime of all lower dirs in the stack and check if they had changed
> before using cache, I'm just not sure if we want to go down this road.
>
> > But I just did this as a test and now I've confused myself as I
> > thought this didn't work when I tried it before:
> >
> > mount -o vers=3D4.2 serverA:/mnt/data /mnt/data
> > mount -t overlay overlay -o
> > metacopy=3Don,rw,lowerdir=3D/mnt/data,upperdir=3D/var/cache/overlay/upp=
erdir,workdir=3D/var/cache/overlay/workdir/test
> > /mnt/overlay
> > chown bob /mnt/overlay/dir1/dir2
> > touch /mnt/overlay/dir1/dir2/file1
> >
> > Now if I mount serverA:/data on another completely seperate NFS client
> > and create dirs or files in serverA:/mnt/data/dir1/dir2, I can also
> > see them appearing (ls -l) on the client with the overlay. I was sure
> > that wasn't working before because of the readdir cache that overlayfs
> > uses...
>
> hmm yeh, you are right.
> For a merged dir, last ovl_dir_release() drops the readdir cache
> from the inode.
> I think this was done to save memory because merged dir caches
> could become quite large.
>
> This is a bit like POSIX readdir rule that a new iteration will
> observe new entries, but much more strict - if you are adding
> entries to underlying layers, all the open fds of the dir need to
> be closed before overlayfs will drop the readdir cache.

Well I think that's fine in my case then as these are just new
directories that get added at this level and I don't think there are
ever any files. Certainly none that would ever be kept open for any
long period of time anyway.

The files and dirs likely to be held open for the duration of the
applications are going to be further down the tree and are going to be
ones I would want to (metadata) copy-up.

> > So I can create dirs on the NFS share within directories that the
> > overlay has already recently "accessed"? Or maybe that's just not
> > guarenteed behaviour and I'm just lucky? NFS server is EL9 and client
> > was EL8 if that makes any odds.
> >
>
> It is expected, but not documented and not guaranteed.
>
> > > > Any files that get copied up to the upper layer are
> > > > guaranteed to never change in the lower NFS filesystem (by it's
> > > > design), but new directories and files that have not yet been copie=
d
> > > > up, can randomly appear over time. Deletions are not so important
> > > > because if it has been deleted in the lower level, then the upper
> > > > level copy failing has similar results (but we should cleanup the
> > > > upper layer too).
> > > >
> > > > If it's possible to get over this first difficult hurdle, then I ha=
ve
> > > > another extra bit of complexity to throw on top - now manually make=
 an
> > > > entire directory tree (of metdata) that we have recursively copied =
up
> > > > "opaque" in the upper layer (currently needs to be done outside of
> > > > overlayfs). Over time or dropping of caches, I have found that this
> > > > (seamlessly?) takes effect for new lookups.
> > > >
> > > > I also noticed that in the current implementation, this "opaque"
> > > > transition actual breaks access to the file because the metadata
> > > > copy-up sets "trusted.overlay.metacopy" but does not currently add =
an
> > > > explicit "trusted.overlay.redirect" to the correspnding lower layer
> > > > file. But if it did (or we do it manually with setfattr), then it i=
s
> > > > possible to have an upper level directory that is opaque, contains
> > > > file metadata only and redirects to the data to the real files on t=
he
> > > > lower NFS filesystem.
> > > >
> > > > Why the hell would you want to do this? Well, for the case where yo=
u
> > > > are distributing software to many machines, having it on a shared N=
FS
> > > > filesystem is convenient and reasonably atomic. But when you have
> > > > sofware with many many PATHs (LD_LIBRARY, PYTHON, etc), you can cre=
ate
> > > > some pretty impressive negative lookups across all those NFS hosted
> > > > directories that can overhelm a single NFS storage server at scale.=
 By
> > > > "caching" or localising the entire PATH directory metadata locally =
on
> > > > each host, we can serve those negative lookups from local opaque
> > > > directories without traversing the network.
> > > >
> > > > I think this is a common enough software distribution problem in la=
rge
> > > > systems and there are already many different solutions to work arou=
nd
> > > > it. Most involve localising the software on demand from a central
> > > > repository.
> > > >
> > > > Well, I just wondered if it could ever be done using an overlay in =
the
> > > > way I describe? But at the moment, it has to deal with a sporaidcal=
ly
> > > > changing lower filesystem and a manually hand crafted upper
> > > > filesystem. While I think this might all work fine if the filesyste=
ms
> > > > can be mounted and unmounted between software runs, it would be eve=
n
> > > > better if it could safely be done "online".
> > >
> > > How about this for a workaround:
> > >
> > > From your explanations, I understand that you are expecting only spec=
ific
> > > directories to grow (e.g.  /blah/thing/ and /blah/thing/UIID*/), whil=
e other
> > > directories are immutable (e.g. /blah/thing/UIIDA/versionXX/) is that=
 correct?
> >
> > Yes, pretty much. Maybe the top 3 levels of directories can grow new
> > entries, but once you get to the third or fourth level and all the way
> > to the end of the trees, all those files and dirs are going to be
> > immutable - they will only ever be deleted.
> >
> > > Can you monitor those directories mtime on NFS using a dedicated serv=
ice?
> >
> > That might be feasible, but I think there might be a lot of
> > directories to check... 3000 on the root level, x 10 average on the
> > second level and then 2000+ clients all checking mtime... Our software
> > NFS volume is currently 10 million inodes used.
> >
> > > If you can then there might be a workable solution to your problems:
> > >
> > > - Instead of chown -R to copy up all dirs and metacopy all files
> > > create an identical opaque directory hierarchy and *move* all the
> > > files into the opaque directory hierarchy.
> > > - When the service detects a new subdir on NFS, add the subdir to the
> > > opaque directory hierarchy and *move* the files from the merged subdi=
r
> > > to the opaque subdir of the same name.
> > >
> > > The result is that:
> > > - all the directories in the opaque hierarchy are opaque as you wante=
d
> > > - all the files have metacopy and absolute redirect
> > > - if you take care no to expose the merged hierarchy to users (only t=
o
> > >   the service), then the overlayfs merged hierarchy will not have any
> > >   readdir caches (service only iterates on NFS directly)
> > > - if service only ever accesses the merged hierarchy as the move sour=
ce
> > >   then there should be no negative lookup caches in the merged hierar=
chy
> > > - all this happens legitimately while overlayfs is mounted, without
> > >   having to manually tweak trusted.overlay xattrs and drop caches
> > >
> > > Assuming that I didn't miss anything and this can work for you,
> > > how can we document it to make the behavior "defined"?
> >
> > Okay, bear with me while I digest this and do some more tests to see
> > if I fully understand what you are suggesting. But I *think* you are
> > saying that I would eventually have a metacopy of *every* directory
> > tree and file from the lower NFS filesystem and only that would be
> > accessed by processes to run the software?
>
> Yeh, I thought that is what you wanted to achieve.
>
> >
> > I should clarify that I was thinking of this as more of an optional
> > slow moving cache. In other words, if I never create an upper opaque
> > directory and contents, I still want to serve the all data and paths
> > as per normal from the lower NFS filesystem. The access should always
> > "fall through" to the NFS software volume in the absence of any upper
> > layer modifications or copies.
> >
> > Then I would have a service watching for access to lib/module type
> > dirs only (systemtap or bpf) and "promote" frequently hit (maybe even
> > just noent heavy) directories to opaque metadata only copies on the
> > upper (local filesystem) layer. I reckon this would only be a small
> > fraction of the total 10 million inodes.
> >
> > So it's different to the data only layer or a composefs style
> > construct where the only access is via a pre-determined complete
> > metadata tree. Instead, I am trying to dynamically detect workloads
> > and only create select local opaque copies such that at some point in
> > the near future, access will be accelerated by the local copy. It
> > doesn't even matter if it takes many hours before the upper layer
> > opaque metadata cache starts to be used (i.e. after cache timeout or
> > eviction) - it is still useful that the cache will then work for many
> > weeks hence and after umounts and reboots.
> >
> > I would rather not pre-create complete metadata trees (ala composefs)
> > as there are just too many files and directories and much of it
> > probably never gets accessed. I would much prefer to be able to do it
> > on demand as a service for accelerating small parts of the entire tree
> > (i.e. lib/module directories).
> >
>
> I understand.
> It makes sense.
>
> I remember tossing the idea of "finalizing" the merged dir copy up -
> meaning that at the end of ovl_dir_read_merged(), overlayfs knows
> if the upper entries shadow all the lower entries, and in this case, the
> lower layers NEVER need to be iterated again, so some xattr could
> be set on the upper dir to indicate that the copy up on the dir content
> has been completed.
>
> After the copy up of dir content has been completed, then ovl_lookup()
> should not continue to lookup children of this merged dir in lower layers
> unless it was redirected by upper layer.
>
> It is not a trivial change, but I think it can be beneficial.
>
> The good thing about this is that there is no need for a new API -
> all your service would need to do is chown -R as you tried to do and
> it will "just work" - no more unneeded lookups in NFS layer.

Well, that is an interesting idea. I'm not sure how you would
determine that a merged dir has been "completely" copied up (comparing
readdir results?). And how would this differ to setting the "opaque"
xattr on the dir (but automatically)? Would it need a new xattr?

It also means that all subsequent dirs in the lower tree would also be
"opaque" even if they have not been checked for copy-up completeness?
Or they would get a redirect until it could be determined they were
completely copied up?

I also won't pretend to understand how you could do that for a
recursive copy up without momentarily disrupting access. Like if you
did a recursive copy up and the top level dirs complete first while
the lower contents haven't been totally copied up yet?

It sounds complex :)

> The bad thing for you is that this feature may get in the way of your
> requirement to observe new entries at the top level dirs, because if
> overlayfs observes that all the /blah/thing/ entries have been copied up,
> it will stop looking for new entries in lower layers.
>
> Unless you can make sure that there is always some lower entry
> (e.g. /blah/thing/immutable) that will never be copied up and keep
> its parent dir a merged dir forever?

Yea, I think that is totally acceptable. Create a ".ovlmerge" hidden
file in all the top level dirs that should never get copied up. I
figure that the only way the upper dirs would be created, is if parts
of the lower tree are being copied up and those directories were
created as part of that copy-up tree.

> > > My thinking is:
> > >
> > > "Changes to the underlying filesystems while part of a mounted overla=
y
> > > filesystem are not allowed.  If the underlying filesystem is changed,
> > > the behavior of the overlay is undefined, though it will not result i=
n
> > > a crash or deadlock.
> > >
> > > One exception to this rule is changes to underlying filesystem object=
s
> > > that were not accessed by a overlayfs prior to the change.
> > > In other words, once accessed from a mounted overlay filesystem,
> > > changes to the underlying filesystem objects are not allowed."
> > >
> > > But this claim needs to be proved and tested (write tests),
> > > before the documentation defines this behavior.
> > > I am not even sure if the claim is correct.
> > >
> > > One more thing that could help said service is if overlayfs
> > > supported a hybrid mode of redirect_dir=3Dfollow,metacopy=3Don,
> > > where redirect is enabled for regular files for metacopy, but NOT
> > > enabled for directories (which was redirect_dir original use case).
> > >
> > > This way, the service could run the command line:
> > > $ mv /ovl/blah/thing /ovl/local
> > > then "mv" will get EXDEV for moving directories and will create
> > > opaque directories in their place and it will recursively move all
> > > the files to the opaque directories.
> >
> > Okay, I think I see what you are getting at but I need to test the
> > patch to make sure :)

Sorry, I will try and test the patch this week as I am actually
curious about using it to create offline handcrafted overlay trees
too. So rather than run a combination of truncate, touch, chown,
chmod, setfattr commands, mount an overlay with your patch, move the
dirs around, umount and then use the resulting metadata overlay as a
read-only overlay from then on.

I'm still toying with the idea of creating one (enormous) read-only
overlay with all the lib/plugin directories as opaque directories and
just accepting that I might only refresh it once a day and clients
might only remount it once a week... Not great, but some amount of
local lookup acceleration is better than none.

I think the main problem with using this patch for my use case is that
as soon as you do the mv, you break any processes that might be
scanning those dirs at that instant or any new ones that start up. It
may be possible to have my userspace daemon choose the right time to
run the mv, but it's hard to predict how fast it would take to
complete.

> > I mean I also tested hand crafting the metadata upper layer outside of
> > the overlay while it was still mounted too. To replicate what overlay
> > does natively, it involved running truncate, chmod, chown, touch using
> > the reference flag to the origin file on NFS, and then finally setting
> > trusted.overlay.opaque and trusted.overlay.redirect.
> >
> > My rationale here is that after some time in the future the overlay
> > will drop it's cache of the upper layer contents and re-read my hand
> > crafted version instead. I naively figured that for (read-only) open
> > files, the file is the same NFS destination, but open dirs at this
> > time might cause issues.
> >
> > This is defintely extra "undefined" behaviour and so I thought it
> > would be much safer to be able to do it via the overlay itself (like
> > chown and/or the mv you are suggesting).
> >
>
> Mangling with overlayfs xattrs is way too abusive and risky..

Yes, I'm starting to think that, but again, sometimes when behaviour
is undefined, it might also actually work for one's particular
workload (as long as that is well defined and unchanging).

Thanks again for the feedback.

Daire
