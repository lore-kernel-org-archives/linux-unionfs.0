Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FD6F9EC
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 15:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721057765; cv=none; b=SGR3VUPuTsLPICog9ypBVEO7rKqwDnX+W80MaAA8YF6f5ulOjVKdD7HGbhmJhL2w5XLeWkWBzFenaFpTI0s8/ZumoQ724UgpsuIi4A9hX2zKVAAzkAYUGn2ozYtWG8thNhXD+wiJlzcc61CtrJKUdDHshBL7hqGemyCjDPHFDHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721057765; c=relaxed/simple;
	bh=r3QdCFyWJYXfMe0Mj5RKFeDU7tqPa05ZXPbYgsiyfcQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GqurKpt4ZYjlZpxvACe+oJtynlEA10qnBNL6oD77FOI1Ec3ndgE8lAu3ABH2aTx6dp1ZX50vmugLQUp/EKvRJw2QovKOb/AjCqi8C9i8JxkxxBpWMdMvSpDSFoEp0gOaUth9w5x9CPaa1i7csg2ZAX5aTCPs3jRQ2OngyJRGxBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com; spf=pass smtp.mailfrom=dneg.com; dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b=Yyy4bySX; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dneg.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b="Yyy4bySX"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-4f2ee3be4a1so2050085e0c.2
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 08:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1721057762; x=1721662562; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r3QdCFyWJYXfMe0Mj5RKFeDU7tqPa05ZXPbYgsiyfcQ=;
        b=Yyy4bySXVX4/QzHu1onPWoPhPSS3Ga1jYMvLWn5IqrcPFr8kYfiLRfuOXfvTCXYtfm
         wSmFGvkn3qOaxkQYtWPgszYIQIk/hoTXmY6B944AZMvqGk7Kxks7JKij8Jiv5fYV7nbg
         wDTzTV5RbgNCdzuG/FWCsCQgoQQR1mfav3QEUP09NvX+HjSEmLvSfLnk3RpSaDi7UwLn
         s0IU27VYa4CMJiX+7MmV7MZBT94e3fQawlLFXYtkYueHBpc5uhsmFXEvcYgjmXgbOiDt
         WxsetAQ9koTHNGlkB/mDQdre32hzOZjj5STXgtasVG1FYJ6zoHqWwZoGdHpIeTkLMVpR
         qEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721057762; x=1721662562;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r3QdCFyWJYXfMe0Mj5RKFeDU7tqPa05ZXPbYgsiyfcQ=;
        b=S4c9AMNpxHcmgrBfl1yfBYyGaPjlZD0g4KWng6HCvoExXrx4FWZVVvUQryr5YssLvU
         dfXecB1rh6kp2ozmgpA4AG+CpuTQlOkap15LhDnUCnEdcztrCwyGfK+nmaLfTXNiwWDV
         QMWPFPPuBp51my0BPXfrxwIBh6q0aq26R7fJHq2hKs6Tjzyogr5Y2Ql7EF+NVHTpAkCU
         uipuphADTQqAVsF18aSebWyGeYKqClb0duze0rJtYzgu3d5jsohtwz2GqbCjPZddPqh4
         PWU+o3Ts4sofB1O+DUoJSEvgtalPCe98ejYoGATgD10oCwKVhNVNix70QJSn4jEAY/hf
         jBzw==
X-Gm-Message-State: AOJu0YyqH1LINdO5MsR1EMOK0LG63druojXJuv0rBNKcUVufM3wZC4lP
	xX1LGG80HAcicMAjJ1BXQn63Yqm2MBqlcIZIxCuSgT2hYw8VSVyRJ5Y0UIgxE1CXCl7jJW0djQr
	dHpUdks4mq86tdUyf5yHkf5naqnvT0drAA5Q75A==
X-Google-Smtp-Source: AGHT+IG0PJDoUEG9KXqP8YzdDWeC06s37qMaCSxRrFhk6y7lT07Mlq8XUJLtzs6FsdYZ2iRg8zNDre7W2duk+sqIlwg=
X-Received: by 2002:a05:6122:309f:b0:4ed:36f:9b38 with SMTP id
 71dfb90a1353d-4f4cd2ec6dcmr304412e0c.9.1721057760690; Mon, 15 Jul 2024
 08:36:00 -0700 (PDT)
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
 <CAPt2mGOkxUE7t22SrcW6hHW+OaccNuB8Xem-hVAv-aiyteiXqw@mail.gmail.com> <CAOQ4uxgyjXU7_-SnpbfvDTFzjKekB+sxRp3Ea+LSrrQrkMcf1w@mail.gmail.com>
In-Reply-To: <CAOQ4uxgyjXU7_-SnpbfvDTFzjKekB+sxRp3Ea+LSrrQrkMcf1w@mail.gmail.com>
From: Daire Byrne <daire@dneg.com>
Date: Mon, 15 Jul 2024 16:35:23 +0100
Message-ID: <CAPt2mGP_fS2MOVzat9kFE-W+JkUXCpS87WfJEb_YiosR5Tn-NA@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Jul 2024 at 15:15, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > I understand.
> > > It makes sense.
> > >
> > > I remember tossing the idea of "finalizing" the merged dir copy up -
> > > meaning that at the end of ovl_dir_read_merged(), overlayfs knows
> > > if the upper entries shadow all the lower entries, and in this case, the
> > > lower layers NEVER need to be iterated again, so some xattr could
> > > be set on the upper dir to indicate that the copy up on the dir content
> > > has been completed.
> > >
> > > After the copy up of dir content has been completed, then ovl_lookup()
> > > should not continue to lookup children of this merged dir in lower layers
> > > unless it was redirected by upper layer.
> > >
> > > It is not a trivial change, but I think it can be beneficial.
> > >
> > > The good thing about this is that there is no need for a new API -
> > > all your service would need to do is chown -R as you tried to do and
> > > it will "just work" - no more unneeded lookups in NFS layer.
> >
> > Well, that is an interesting idea. I'm not sure how you would
> > determine that a merged dir has been "completely" copied up (comparing
> > readdir results?).
>
> overlay readdir of merged dir NEEDS to merge lower entries
> that DO NOT exist in the upper layer - if there are not such entries
> found, looking in the lower layer next time is futile.
>
> > And how would this differ to setting the "opaque"
> > xattr on the dir (but automatically)?
>
> The lower layer still has information that overlayfs needs,
> and ovetrlayfs needs to be able to follow redirects into lower layer.
> This is not going to work with an opaque upper dir.

I guess as long as the upperdir can now serve all the lookups and
negative lookups for a given directory (and optionally entire
subsequent directory tree) without needing to consult with the lower
directory specifically for them, that's all I care about :)

> > Would it need a new xattr?
> >
>
> Maybe, or use the combination of "opaque" + "redirect" to
> describe this hybrid type of directory (the dir content was fully
> copied up, but redirects may still follow to lower entries.
> Essentially, this is equivalent to a lower-most directory (implicitly
> opaque dir) that can follow redirects into a data-only layer.
>
> > It also means that all subsequent dirs in the lower tree would also be
> > "opaque" even if they have not been checked for copy-up completeness?
>
> No. A directory inode is a sort of a file whose "data" is the dir content.
> "copy-up completeness" means the list of entries have been copied up
> (not recursively).
>
> > Or they would get a redirect until it could be determined they were
> > completely copied up?
>
> readdir operated on a single dir inode.
> readdir of a directory can end up making it "half-opaque"
> nothing recursive about it - application can do this recursively
> as it wishes.
>
> >
> > I also won't pretend to understand how you could do that for a
> > recursive copy up without momentarily disrupting access. Like if you
> > did a recursive copy up and the top level dirs complete first while
> > the lower contents haven't been totally copied up yet?
>
> Not doing anything recursive.

I guess what I meant by recursive was the proposed "chown -R" that
would "promote" the metadata to the upper layer recursively.

I think you answered my question by saying that both files &
directories in a "complete" copy-up directory would still get a
redirect so it wouldn't break access while the chown was running? Once
it gets to the next level, the new xatrr (or opaque + redirect) would
then be added to those directories etc etc. all the way down.

> >
> > It sounds complex :)
>
> Not really. The patch is not trivial, but the concept is simple.
> If I find a few hours, I will post a demo.

That would be cool! Always happy to test patches.

> > > > > One more thing that could help said service is if overlayfs
> > > > > supported a hybrid mode of redirect_dir=follow,metacopy=on,
> > > > > where redirect is enabled for regular files for metacopy, but NOT
> > > > > enabled for directories (which was redirect_dir original use case).
> > > > >
> > > > > This way, the service could run the command line:
> > > > > $ mv /ovl/blah/thing /ovl/local
> > > > > then "mv" will get EXDEV for moving directories and will create
> > > > > opaque directories in their place and it will recursively move all
> > > > > the files to the opaque directories.
> > > >
> > > > Okay, I think I see what you are getting at but I need to test the
> > > > patch to make sure :)
> >
> > Sorry, I will try and test the patch this week as I am actually
> > curious about using it to create offline handcrafted overlay trees
> > too. So rather than run a combination of truncate, touch, chown,
> > chmod, setfattr commands, mount an overlay with your patch, move the
> > dirs around, umount and then use the resulting metadata overlay as a
> > read-only overlay from then on.
> >
>
> That sounds much better than mangling with overlayfs xattrs.
>
> > I'm still toying with the idea of creating one (enormous) read-only
> > overlay with all the lib/plugin directories as opaque directories and
> > just accepting that I might only refresh it once a day and clients
> > might only remount it once a week... Not great, but some amount of
> > local lookup acceleration is better than none.
> >
> > I think the main problem with using this patch for my use case is that
> > as soon as you do the mv, you break any processes that might be
> > scanning those dirs at that instant or any new ones that start up. It
> > may be possible to have my userspace daemon choose the right time to
> > run the mv, but it's hard to predict how fast it would take to
> > complete.
> >
>
> Confused. I thought you were going to use the patch for offline preparation
> of metacopy layers.

Sorry, I did mean only for the case where I might create the desired
upper layer for reuse later on (ie offline changes), your patch sounds
like a really useful and optimised time saver compared to my
hand-crafted method. I am still considering the offline method if
there proves to be no other alternative.

But for the case where I would want a seamless online way to achieve
the same upper layer opaque directories, then obviously moving
directory trees even momentarily out of position and back again would
likely break software just starting up in that moment.

And coordinating a background daemon that does the mv, with users who
randomly start applications sounds like a difficult problem.

> Note that once you did mv into an opaque tree,
> you can move the opaque dir back into its original location
> (e.g. /blah/think/UUID...) and the dir will remain opaque,
> because EXDEV is only generated when trying to move
> merged dirs.
> Moving opaque upper dirs around is allowed and should work.

Yes exactly, this would likely work most of the time while online
except when some software is expecting the files to always be located
in an immutable path location and the mv is in progress? Unless I am
totally misunderstanding (always a strong possibility).

Basically, I need to be able to continue serving the same files and
paths even while the copy-up metadata process for any part of the tree
is in progress. And it sounds like your idea of considering a copy-up
of a merged dir as "complete" (and essentially opaque) would be the
way to do that without files or dirs ever moving or losing access even
momentarily.

Daire
