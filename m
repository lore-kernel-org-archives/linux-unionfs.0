Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8CB1E89C
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 14:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721052929; cv=none; b=nRSSB+YqJPW88B2fqmQXD5Jd4E5Hsi7nbuYn+W9i2O1SBZma8hq9t9mGnuinkV1vSd29Sb+IDmxcUB4V0yeJBWbv8lMAqf1PzsRcwHr0TUh9nRpATmKNrjs26wGD3lXHF8ccViUpKoKvmJgP+N96469Cr6modLC3PQnDcoa5KCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721052929; c=relaxed/simple;
	bh=WbGfS3Fne/E+3NZambauS0HXLnbPJoHPynU25RYO0JE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X1KPD0JuL80Dta4mPe18cZW/MzT+8gechwhZnNX+jf6l8rfCZoYfV+vyTrsOy2v/1DezRDVeGUE6oFOOBcPn2tBPqyz2Bv63oJ8Zc9rm2V24bA8IFVG2LHy3+uYG651gTfuGkDF2NCpOJ5+9WYki2jWPLrSezh7cuguqi5/kLtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SeNMJtb4; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SeNMJtb4"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-79f19f19059so276936985a.0
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 07:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721052925; x=1721657725; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WbGfS3Fne/E+3NZambauS0HXLnbPJoHPynU25RYO0JE=;
        b=SeNMJtb4SF7xKnhGTyeL6KNoorpY+hnIuXM9kArtaocODdJhwaSayza7YiY26GtNU2
         rM+mKtAO0OWuFA7oK+vQfktc/1/S0iLfghQ0btCDxoyNiFVkG7CkDYiXRHjatI3zyJcP
         8ot3GTXEWXOamTVvFvR4yZVxY9yt0NAQDTbDhdS/wzThAi/tS5q9VS44AzXgTlzbtDut
         uv/wf5uV++5TpP8MNkbezfvpALe2g4KiOzDbok2fK28eamPvRsUaXW69WnlYtACg3ciq
         raODfnYjGdpJc1yJo9V94HHwg4Q1E3YZKv9CvjcN2ghX4CXhLuzynvFgQlRvyEVWNuHm
         7ziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721052925; x=1721657725;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WbGfS3Fne/E+3NZambauS0HXLnbPJoHPynU25RYO0JE=;
        b=LbNg67QaTYD/HyJSMqBkKQQrSsE/OroL4Fhe7PjYyMIVpv7aTece52SujfTXHJLjS/
         a9GZ4VIa+qzXNWS4EmssGYlEV+AgP7mEo7QElwWWIOKk206yi3OZ2WLTewb0x7HFKAaB
         KQvVVhsNOh2GG4ixjQ9Bq/yIg8WA8Vx4ytF7TSwndhL99gIlLua5Utmyu/3B+RzGOa+A
         EzJ/OjEizSdKvNMOJCDw75QDgwuezEsUYb+0jrra+xYjZOCrQ8DiqG5+6G26k6am39oe
         AFL8Jc05G45xbRQoZepWCX2w4qOc76oGaGq8+t3VdQKn9dp8CwOUkoFXSm/ejMhZz06+
         i2cA==
X-Gm-Message-State: AOJu0YyXoJMeAS+C6h5uUchidYeP35I9B9qMgbQEjvBoL/bY9t0evuP7
	elAqKvUGboyxfWY+S8FbGaANARDwy5rFNK0qKI3dMURi91y/4DVlQY+Nh0l9oEh02PlakEzH/Qv
	MGCb1yuiO7mQ3ahSSAc+NqUNuuUM=
X-Google-Smtp-Source: AGHT+IGXefZc9HA/MuJ46jAHLRDxsmZwCUB5fWFEFP+/7D1p8S6E9nPcb35YjzKR0AhNmjSv+mugwcQGkFHkMISReXw=
X-Received: by 2002:a05:620a:2985:b0:79d:69b5:aaf7 with SMTP id
 af79cd13be357-79f19a52704mr2446128385a.11.1721052925206; Mon, 15 Jul 2024
 07:15:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
 <CAPt2mGPWzGGZdGGRg2CEQw0QnHNSm7o7xpHow65R+iJ0BO5CMQ@mail.gmail.com>
 <CAOQ4uxg16b7SJrsN=5kvE0QSD94-VoHiWTCvGVbGEcaadfVmeA@mail.gmail.com> <CAPt2mGOkxUE7t22SrcW6hHW+OaccNuB8Xem-hVAv-aiyteiXqw@mail.gmail.com>
In-Reply-To: <CAPt2mGOkxUE7t22SrcW6hHW+OaccNuB8Xem-hVAv-aiyteiXqw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 15 Jul 2024 17:15:12 +0300
Message-ID: <CAOQ4uxgyjXU7_-SnpbfvDTFzjKekB+sxRp3Ea+LSrrQrkMcf1w@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Daire Byrne <daire@dneg.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > I understand.
> > It makes sense.
> >
> > I remember tossing the idea of "finalizing" the merged dir copy up -
> > meaning that at the end of ovl_dir_read_merged(), overlayfs knows
> > if the upper entries shadow all the lower entries, and in this case, the
> > lower layers NEVER need to be iterated again, so some xattr could
> > be set on the upper dir to indicate that the copy up on the dir content
> > has been completed.
> >
> > After the copy up of dir content has been completed, then ovl_lookup()
> > should not continue to lookup children of this merged dir in lower layers
> > unless it was redirected by upper layer.
> >
> > It is not a trivial change, but I think it can be beneficial.
> >
> > The good thing about this is that there is no need for a new API -
> > all your service would need to do is chown -R as you tried to do and
> > it will "just work" - no more unneeded lookups in NFS layer.
>
> Well, that is an interesting idea. I'm not sure how you would
> determine that a merged dir has been "completely" copied up (comparing
> readdir results?).

overlay readdir of merged dir NEEDS to merge lower entries
that DO NOT exist in the upper layer - if there are not such entries
found, looking in the lower layer next time is futile.

> And how would this differ to setting the "opaque"
> xattr on the dir (but automatically)?

The lower layer still has information that overlayfs needs,
and ovetrlayfs needs to be able to follow redirects into lower layer.
This is not going to work with an opaque upper dir.

> Would it need a new xattr?
>

Maybe, or use the combination of "opaque" + "redirect" to
describe this hybrid type of directory (the dir content was fully
copied up, but redirects may still follow to lower entries.
Essentially, this is equivalent to a lower-most directory (implicitly
opaque dir) that can follow redirects into a data-only layer.

> It also means that all subsequent dirs in the lower tree would also be
> "opaque" even if they have not been checked for copy-up completeness?

No. A directory inode is a sort of a file whose "data" is the dir content.
"copy-up completeness" means the list of entries have been copied up
(not recursively).

> Or they would get a redirect until it could be determined they were
> completely copied up?

readdir operated on a single dir inode.
readdir of a directory can end up making it "half-opaque"
nothing recursive about it - application can do this recursively
as it wishes.

>
> I also won't pretend to understand how you could do that for a
> recursive copy up without momentarily disrupting access. Like if you
> did a recursive copy up and the top level dirs complete first while
> the lower contents haven't been totally copied up yet?

Not doing anything recursive.

>
> It sounds complex :)

Not really. The patch is not trivial, but the concept is simple.
If I find a few hours, I will post a demo.


> > > > One more thing that could help said service is if overlayfs
> > > > supported a hybrid mode of redirect_dir=follow,metacopy=on,
> > > > where redirect is enabled for regular files for metacopy, but NOT
> > > > enabled for directories (which was redirect_dir original use case).
> > > >
> > > > This way, the service could run the command line:
> > > > $ mv /ovl/blah/thing /ovl/local
> > > > then "mv" will get EXDEV for moving directories and will create
> > > > opaque directories in their place and it will recursively move all
> > > > the files to the opaque directories.
> > >
> > > Okay, I think I see what you are getting at but I need to test the
> > > patch to make sure :)
>
> Sorry, I will try and test the patch this week as I am actually
> curious about using it to create offline handcrafted overlay trees
> too. So rather than run a combination of truncate, touch, chown,
> chmod, setfattr commands, mount an overlay with your patch, move the
> dirs around, umount and then use the resulting metadata overlay as a
> read-only overlay from then on.
>

That sounds much better than mangling with overlayfs xattrs.

> I'm still toying with the idea of creating one (enormous) read-only
> overlay with all the lib/plugin directories as opaque directories and
> just accepting that I might only refresh it once a day and clients
> might only remount it once a week... Not great, but some amount of
> local lookup acceleration is better than none.
>
> I think the main problem with using this patch for my use case is that
> as soon as you do the mv, you break any processes that might be
> scanning those dirs at that instant or any new ones that start up. It
> may be possible to have my userspace daemon choose the right time to
> run the mv, but it's hard to predict how fast it would take to
> complete.
>

Confused. I thought you were going to use the patch for offline preparation
of metacopy layers.

Note that once you did mv into an opaque tree,
you can move the opaque dir back into its original location
(e.g. /blah/think/UUID...) and the dir will remain opaque,
because EXDEV is only generated when trying to move
merged dirs.
Moving opaque upper dirs around is allowed and should work.

Thanks,
Amir.
