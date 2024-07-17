Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E5212E75
	for <linux-unionfs@vger.kernel.org>; Wed, 17 Jul 2024 18:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721240159; cv=none; b=iEowqElJ86GnnDg589NI+YKYgiszlOiIsi6aVAlgRK4mmegs2pKw0Sh/uxzi4kpQKSBibmH7KWj562NyDY3cVPHd9xLUrNdBvmxZ8UoZexfV2lD/7R2BJAPKusilUocOXt0F86oSudVDxaGkyydjfkpMS/7wKVHtv1KF9Q6lANs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721240159; c=relaxed/simple;
	bh=dGh4s4c5S/zfiHenh7jvEpxEcYHApFb6Qm/YZnuONYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KO0gSLbUCp62bffzMNxRYNT+GSALQEMDeO5l90yBO/uevuOKI32L92indHNps2ty0zgjiFQh24lfFpdX36jCr0A6VrsATem67SigI4d63jWeuv+OffuWtZHL9UtUREoHf7Y1zKwTtgWVMSH+bKOUFQXmC+nSqbSP4P1WyoQUxc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bWTnJ3UW; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bWTnJ3UW"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3d9c487b2b5so1875b6e.3
        for <linux-unionfs@vger.kernel.org>; Wed, 17 Jul 2024 11:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721240156; x=1721844956; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGh4s4c5S/zfiHenh7jvEpxEcYHApFb6Qm/YZnuONYM=;
        b=bWTnJ3UWjx77oCdcFC3A9GMt1DI4kZ/Gl4lPM8Yp2z/il9n+KH6De3rCHYVxiXlJpD
         3qvJHIu/fxjNloR9EJ+vytO+hYUX02BBcwzaIQ9my0MXH+jkdtbIYdi2PGDdfCsWMQ86
         CrQU124CUFsUXKc2FGjtUqLZ/npQUNOhX5Jb2gtM7QuDai6yRjO/WMb97szAPmGGlg1A
         +CNrudkUO8V8bI8sZr6a1vrBGI4YrwOLwR5w4rbHVnRu6/A1mu9UFDlWEjaxOvvDoAfq
         Yxi0Q3ajX43+4uyW0/3Il+yeMFxhtixuggF2x0zPhhUQ9lewQqL0OH0OYVrpP3iUe8vJ
         Psvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721240156; x=1721844956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dGh4s4c5S/zfiHenh7jvEpxEcYHApFb6Qm/YZnuONYM=;
        b=LAau5qdkmlZsfw/lrgwusWjd1X1mlyzNHvJdA1Bb/3OrbHC2xZm2w0Mavdur3R9SJ5
         xpFx6feDWWH/VEYrm4spkjeBUkYanHPsc7FXGWilx1yelupLxBwgyaVj4DVdyOZWfE+X
         8cmkNQpJam4fgDhSnPR+Bk2zlHxW+Wv91yAsmpVPSSxGs8cCRDFmYQN2n+YOangN8t57
         ++OQQOiTTksBLPflH0e37DMSvtjg668EbE6RPt5t+a9tiKvxLCLr9HqZbmLE9UGWiGl8
         T596hYmVdh9NK30ERUU3Qa+RXGpbA3Z408nutxuOqqWE2npYnrvE8Vp3wr3CN0NubHRu
         xJIA==
X-Gm-Message-State: AOJu0YzpSbq8KCe34VoSN9ViUIlyRNcIa2eZyK1mtP3LlwDBMYx1StxD
	dqRxdYrHfZ4n/EreaCUL6uff1V8jyHMIaLIhmenEHnl3QzxubYFq5PxLO6pyCtqu4hgu7a8EjRE
	nusQ7ToOaYMSQeoNGouJdZHAUlB72TVcL774=
X-Google-Smtp-Source: AGHT+IGVutKTmC8SHsyiziAmPGGUEC0aA7d/TRt0jVjQO2OVzLsZHLWwF9bBmgdtwn5oPSostTg35624sjUkdty/OX0=
X-Received: by 2002:a05:6808:23cf:b0:3d9:dcbc:6b95 with SMTP id
 5614622812f47-3dad5294195mr1919601b6e.31.1721240156202; Wed, 17 Jul 2024
 11:15:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
 <CAPt2mGPWzGGZdGGRg2CEQw0QnHNSm7o7xpHow65R+iJ0BO5CMQ@mail.gmail.com>
 <CAOQ4uxg16b7SJrsN=5kvE0QSD94-VoHiWTCvGVbGEcaadfVmeA@mail.gmail.com>
 <CAPt2mGOkxUE7t22SrcW6hHW+OaccNuB8Xem-hVAv-aiyteiXqw@mail.gmail.com>
 <CAOQ4uxgyjXU7_-SnpbfvDTFzjKekB+sxRp3Ea+LSrrQrkMcf1w@mail.gmail.com>
 <CAPt2mGP_fS2MOVzat9kFE-W+JkUXCpS87WfJEb_YiosR5Tn-NA@mail.gmail.com> <CAOQ4uxhO21UqcppSqoXO7QLOUAHVjRGkN1Ao=WrNGCc7GHaD6w@mail.gmail.com>
In-Reply-To: <CAOQ4uxhO21UqcppSqoXO7QLOUAHVjRGkN1Ao=WrNGCc7GHaD6w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 17 Jul 2024 21:15:43 +0300
Message-ID: <CAOQ4uxjAG_mcZBZ=Yi7i2zVjizEEGiw7mAfM9wu23KqBAGSnug@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Daire Byrne <daire@dneg.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Mike Baynton <mike@mbaynton.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2024 at 9:14=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
>
>
> On Mon, Jul 15, 2024, 6:36=E2=80=AFPM Daire Byrne <daire@dneg.com> wrote:
>>
>> On Mon, 15 Jul 2024 at 15:15, Amir Goldstein <amir73il@gmail.com> wrote:
>> >
>> > > > I understand.
>> > > > It makes sense.
>> > > >
>> > > > I remember tossing the idea of "finalizing" the merged dir copy up=
 -
>> > > > meaning that at the end of ovl_dir_read_merged(), overlayfs knows
>> > > > if the upper entries shadow all the lower entries, and in this cas=
e, the
>> > > > lower layers NEVER need to be iterated again, so some xattr could
>> > > > be set on the upper dir to indicate that the copy up on the dir co=
ntent
>> > > > has been completed.
>> > > >
>> > > > After the copy up of dir content has been completed, then ovl_look=
up()
>> > > > should not continue to lookup children of this merged dir in lower=
 layers
>> > > > unless it was redirected by upper layer.
>> > > >
>> > > > It is not a trivial change, but I think it can be beneficial.
>> > > >
>> > > > The good thing about this is that there is no need for a new API -
>> > > > all your service would need to do is chown -R as you tried to do a=
nd
>> > > > it will "just work" - no more unneeded lookups in NFS layer.
>> > >
>> > > Well, that is an interesting idea. I'm not sure how you would
>> > > determine that a merged dir has been "completely" copied up (compari=
ng
>> > > readdir results?).
>> >
>> > overlay readdir of merged dir NEEDS to merge lower entries
>> > that DO NOT exist in the upper layer - if there are not such entries
>> > found, looking in the lower layer next time is futile.
>> >
>> > > And how would this differ to setting the "opaque"
>> > > xattr on the dir (but automatically)?
>> >
>> > The lower layer still has information that overlayfs needs,
>> > and ovetrlayfs needs to be able to follow redirects into lower layer.
>> > This is not going to work with an opaque upper dir.
>>
>> I guess as long as the upperdir can now serve all the lookups and
>> negative lookups for a given directory (and optionally entire
>> subsequent directory tree) without needing to consult with the lower
>> directory specifically for them, that's all I care about :)
>>
>> > > Would it need a new xattr?
>> > >
>> >
>> > Maybe, or use the combination of "opaque" + "redirect" to
>> > describe this hybrid type of directory (the dir content was fully
>> > copied up, but redirects may still follow to lower entries.
>> > Essentially, this is equivalent to a lower-most directory (implicitly
>> > opaque dir) that can follow redirects into a data-only layer.
>> >
>> > > It also means that all subsequent dirs in the lower tree would also =
be
>> > > "opaque" even if they have not been checked for copy-up completeness=
?
>> >
>> > No. A directory inode is a sort of a file whose "data" is the dir cont=
ent.
>> > "copy-up completeness" means the list of entries have been copied up
>> > (not recursively).
>> >
>> > > Or they would get a redirect until it could be determined they were
>> > > completely copied up?
>> >
>> > readdir operated on a single dir inode.
>> > readdir of a directory can end up making it "half-opaque"
>> > nothing recursive about it - application can do this recursively
>> > as it wishes.
>> >
>> > >
>> > > I also won't pretend to understand how you could do that for a
>> > > recursive copy up without momentarily disrupting access. Like if you
>> > > did a recursive copy up and the top level dirs complete first while
>> > > the lower contents haven't been totally copied up yet?
>> >
>> > Not doing anything recursive.
>>
>> I guess what I meant by recursive was the proposed "chown -R" that
>> would "promote" the metadata to the upper layer recursively.
>>
>> I think you answered my question by saying that both files &
>> directories in a "complete" copy-up directory would still get a
>> redirect so it wouldn't break access while the chown was running? Once
>> it gets to the next level, the new xatrr (or opaque + redirect) would
>> then be added to those directories etc etc. all the way down.
>
>
> Yap.
>
>>
>> > >
>> > > It sounds complex :)
>> >
>> > Not really. The patch is not trivial, but the concept is simple.
>> > If I find a few hours, I will post a demo.
>>
>> That would be cool! Always happy to test patches.
>>
>> > > > > > One more thing that could help said service is if overlayfs
>> > > > > > supported a hybrid mode of redirect_dir=3Dfollow,metacopy=3Don=
,
>> > > > > > where redirect is enabled for regular files for metacopy, but =
NOT
>> > > > > > enabled for directories (which was redirect_dir original use c=
ase).
>> > > > > >
>> > > > > > This way, the service could run the command line:
>> > > > > > $ mv /ovl/blah/thing /ovl/local
>> > > > > > then "mv" will get EXDEV for moving directories and will creat=
e
>> > > > > > opaque directories in their place and it will recursively move=
 all
>> > > > > > the files to the opaque directories.
>> > > > >
>> > > > > Okay, I think I see what you are getting at but I need to test t=
he
>> > > > > patch to make sure :)
>> > >
>> > > Sorry, I will try and test the patch this week as I am actually
>> > > curious about using it to create offline handcrafted overlay trees
>> > > too. So rather than run a combination of truncate, touch, chown,
>> > > chmod, setfattr commands, mount an overlay with your patch, move the
>> > > dirs around, umount and then use the resulting metadata overlay as a
>> > > read-only overlay from then on.
>> > >
>> >
>> > That sounds much better than mangling with overlayfs xattrs.
>> >
>> > > I'm still toying with the idea of creating one (enormous) read-only
>> > > overlay with all the lib/plugin directories as opaque directories an=
d
>> > > just accepting that I might only refresh it once a day and clients
>> > > might only remount it once a week... Not great, but some amount of
>> > > local lookup acceleration is better than none.
>> > >
>> > > I think the main problem with using this patch for my use case is th=
at
>> > > as soon as you do the mv, you break any processes that might be
>> > > scanning those dirs at that instant or any new ones that start up. I=
t
>> > > may be possible to have my userspace daemon choose the right time to
>> > > run the mv, but it's hard to predict how fast it would take to
>> > > complete.
>> > >
>> >
>> > Confused. I thought you were going to use the patch for offline prepar=
ation
>> > of metacopy layers.
>>
>> Sorry, I did mean only for the case where I might create the desired
>> upper layer for reuse later on (ie offline changes), your patch sounds
>> like a really useful and optimised time saver compared to my
>> hand-crafted method. I am still considering the offline method if
>> there proves to be no other alternative.
>>
>> But for the case where I would want a seamless online way to achieve
>> the same upper layer opaque directories, then obviously moving
>> directory trees even momentarily out of position and back again would
>> likely break software just starting up in that moment.
>>
>> And coordinating a background daemon that does the mv, with users who
>> randomly start applications sounds like a difficult problem.
>>
>> > Note that once you did mv into an opaque tree,
>> > you can move the opaque dir back into its original location
>> > (e.g. /blah/think/UUID...) and the dir will remain opaque,
>> > because EXDEV is only generated when trying to move
>> > merged dirs.
>> > Moving opaque upper dirs around is allowed and should work.
>>
>> Yes exactly, this would likely work most of the time while online
>> except when some software is expecting the files to always be located
>> in an immutable path location and the mv is in progress? Unless I am
>> totally misunderstanding (always a strong possibility).
>
>
> You understood correctly.
> This method is not suitable for online promotion.
>
>>
>> Basically, I need to be able to continue serving the same files and
>> paths even while the copy-up metadata process for any part of the tree
>> is in progress. And it sounds like your idea of considering a copy-up
>> of a merged dir as "complete" (and essentially opaque) would be the
>> way to do that without files or dirs ever moving or losing access even
>> momentarily.
>
>
> Yes, that's the idea.
>
> I'll see when I get around to that demo.

I found some time to write the POC patch, but not enough time
to make it work :) - it is failing some fstests.

Since I don't know when I will have time to debug the issues,
here is the WIP if you want to debug it and point out the bugs:

https://github.com/amir73il/linux/commits/ovl-finalize-dir/

Thanks,
Amir.
