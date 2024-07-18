Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EAF12C474
	for <linux-unionfs@vger.kernel.org>; Thu, 18 Jul 2024 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721316322; cv=none; b=ZePvAuIuYnJILZ6zi2sTMRpFQyNX0uCdguFa+95ZseKJcIvP7HH3z6Em2ApuE7LxdCZAbVSWB+FLROy9tXdEurJc8T+Qv8UnnO6luueAwB48rKQYtW/P2wwvDZGC7lexi5Q735PzXsytBFHk74Xm6yLq+793yEoI++oAcid3pSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721316322; c=relaxed/simple;
	bh=liNiBgyr192KqGeRzXZFJ/ojNOFJ8NCz+uQo4g4+bjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M0+u12E2Zx2HbsaSsPfYzO20SL9oQHLiZz0UGgvlD0Xhz4hzSGNpkoQbtxo3kltKta55ULjWYiOFMJrhdNlqmmfhNEdbxrYfE1joCka+yWZXnMk42bu7SipFONJHL/Qy3oyKfztbp371jtxVv1Ar7nhhBK4bva9SY0ebDutbfCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com; spf=pass smtp.mailfrom=dneg.com; dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b=T20bDSc6; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dneg.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b="T20bDSc6"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a77c2d89af8so102419466b.2
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jul 2024 08:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1721316318; x=1721921118; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XKX8PwZdZIq6uth3PyndLBo0cfjWY9w4/NI+tcKshH8=;
        b=T20bDSc6wfoHO3vIw0d9mSlODti2oV0hGNGZpBjPw34pJnplVMbbU50nv00zitt47y
         g8kpxmTmS3JuUctjEWvmZhXL+Xr/UvLOvh0Utr5ffnR2RVIGbI5BeWd8Q+yvvNpZsHdF
         iRkRr8+qjLzsqJf0ViwQjJ+mwiVyz8SsYabZ4K7/yK2I9Lp9EV3r3/D7k4BVXlcyAzCo
         mcUOIqH8umtjrmg0e16mBrPzFcu55PyIta7+uOe+ttXaWYlyg8DDNUrgWJEbk9Q2K3cS
         4A85WAug3GNWgpUqKz6oXd65TGsvLTimy6nismt8d3eqzycDZkfz7VFWQ7Mlf7UVY4/c
         +t9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721316318; x=1721921118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XKX8PwZdZIq6uth3PyndLBo0cfjWY9w4/NI+tcKshH8=;
        b=AKgF4VVrNhKlmAqA5R/j5t8aeU76NNRYimBAQbJ5xzDiiJnvopGO6VjYtSyLQGy6+b
         qlG1TAqCr7E4X93eD+r/qMXREifcBNzfj9HJZ60uvAMM7wHAR/tWDZFCqe6pRkbAfFpr
         bBN8zfWLATS4+VqYxHs0m+9yjxQRCU6eve5Rm1L269BnS5d/PHvnGU6wIj1BHQE5Qz9F
         CIjivTdgSTm4KOxLSSZbNtrJBhl80v1QjkkdHFK/rzFw+z/pgMWw1xH8ddHnr8l9UdRs
         VIUF0a+3FZQxYqpRjJ6sDkFleVWwj4zQClXhgCUfugjb/azhs37RGu8k4s6ttLntmkwD
         nWxg==
X-Gm-Message-State: AOJu0Yz0/p+yNaOmWAoZHqoslYcqe8tQVSCSdFf87lTkQ5glySyVzpBk
	JMGTYnVfkUdnYahvHkPWaTEsWeBMlv5/hXivU2iQy3B+w6MrXcMeN3PJpttX7E9dE20gro5Bead
	DxhMghJqtmzhd9tCN6D8aIbddYbl642HX8wRglA==
X-Google-Smtp-Source: AGHT+IEvB2Gg0gO9BNsw52HCjdsQrHWf/v5K59O99N7TgaSHeN9vGkSlWbpck4wrthwZDA3wRnsgFIkwkrUPUxsFF5U=
X-Received: by 2002:a17:907:2d94:b0:a72:8a0b:9bc4 with SMTP id
 a640c23a62f3a-a7a01115c7bmr533314466b.6.1721316318411; Thu, 18 Jul 2024
 08:25:18 -0700 (PDT)
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
 <CAPt2mGP_fS2MOVzat9kFE-W+JkUXCpS87WfJEb_YiosR5Tn-NA@mail.gmail.com>
 <CAOQ4uxhO21UqcppSqoXO7QLOUAHVjRGkN1Ao=WrNGCc7GHaD6w@mail.gmail.com> <CAOQ4uxjAG_mcZBZ=Yi7i2zVjizEEGiw7mAfM9wu23KqBAGSnug@mail.gmail.com>
In-Reply-To: <CAOQ4uxjAG_mcZBZ=Yi7i2zVjizEEGiw7mAfM9wu23KqBAGSnug@mail.gmail.com>
From: Daire Byrne <daire@dneg.com>
Date: Thu, 18 Jul 2024 16:24:42 +0100
Message-ID: <CAPt2mGNdNtSFQchwCFD9r1cDa4URJ7BVF7HwuzQUCp2qK30shw@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Mike Baynton <mike@mbaynton.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jul 2024 at 19:15, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jul 15, 2024 at 9:14=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> >
> >
> > On Mon, Jul 15, 2024, 6:36=E2=80=AFPM Daire Byrne <daire@dneg.com> wrot=
e:
> >>
> >> On Mon, 15 Jul 2024 at 15:15, Amir Goldstein <amir73il@gmail.com> wrot=
e:
> >> >
> >> > > > I understand.
> >> > > > It makes sense.
> >> > > >
> >> > > > I remember tossing the idea of "finalizing" the merged dir copy =
up -
> >> > > > meaning that at the end of ovl_dir_read_merged(), overlayfs know=
s
> >> > > > if the upper entries shadow all the lower entries, and in this c=
ase, the
> >> > > > lower layers NEVER need to be iterated again, so some xattr coul=
d
> >> > > > be set on the upper dir to indicate that the copy up on the dir =
content
> >> > > > has been completed.
> >> > > >
> >> > > > After the copy up of dir content has been completed, then ovl_lo=
okup()
> >> > > > should not continue to lookup children of this merged dir in low=
er layers
> >> > > > unless it was redirected by upper layer.
> >> > > >
> >> > > > It is not a trivial change, but I think it can be beneficial.
> >> > > >
> >> > > > The good thing about this is that there is no need for a new API=
 -
> >> > > > all your service would need to do is chown -R as you tried to do=
 and
> >> > > > it will "just work" - no more unneeded lookups in NFS layer.
> >> > >
> >> > > Well, that is an interesting idea. I'm not sure how you would
> >> > > determine that a merged dir has been "completely" copied up (compa=
ring
> >> > > readdir results?).
> >> >
> >> > overlay readdir of merged dir NEEDS to merge lower entries
> >> > that DO NOT exist in the upper layer - if there are not such entries
> >> > found, looking in the lower layer next time is futile.
> >> >
> >> > > And how would this differ to setting the "opaque"
> >> > > xattr on the dir (but automatically)?
> >> >
> >> > The lower layer still has information that overlayfs needs,
> >> > and ovetrlayfs needs to be able to follow redirects into lower layer=
.
> >> > This is not going to work with an opaque upper dir.
> >>
> >> I guess as long as the upperdir can now serve all the lookups and
> >> negative lookups for a given directory (and optionally entire
> >> subsequent directory tree) without needing to consult with the lower
> >> directory specifically for them, that's all I care about :)
> >>
> >> > > Would it need a new xattr?
> >> > >
> >> >
> >> > Maybe, or use the combination of "opaque" + "redirect" to
> >> > describe this hybrid type of directory (the dir content was fully
> >> > copied up, but redirects may still follow to lower entries.
> >> > Essentially, this is equivalent to a lower-most directory (implicitl=
y
> >> > opaque dir) that can follow redirects into a data-only layer.
> >> >
> >> > > It also means that all subsequent dirs in the lower tree would als=
o be
> >> > > "opaque" even if they have not been checked for copy-up completene=
ss?
> >> >
> >> > No. A directory inode is a sort of a file whose "data" is the dir co=
ntent.
> >> > "copy-up completeness" means the list of entries have been copied up
> >> > (not recursively).
> >> >
> >> > > Or they would get a redirect until it could be determined they wer=
e
> >> > > completely copied up?
> >> >
> >> > readdir operated on a single dir inode.
> >> > readdir of a directory can end up making it "half-opaque"
> >> > nothing recursive about it - application can do this recursively
> >> > as it wishes.
> >> >
> >> > >
> >> > > I also won't pretend to understand how you could do that for a
> >> > > recursive copy up without momentarily disrupting access. Like if y=
ou
> >> > > did a recursive copy up and the top level dirs complete first whil=
e
> >> > > the lower contents haven't been totally copied up yet?
> >> >
> >> > Not doing anything recursive.
> >>
> >> I guess what I meant by recursive was the proposed "chown -R" that
> >> would "promote" the metadata to the upper layer recursively.
> >>
> >> I think you answered my question by saying that both files &
> >> directories in a "complete" copy-up directory would still get a
> >> redirect so it wouldn't break access while the chown was running? Once
> >> it gets to the next level, the new xatrr (or opaque + redirect) would
> >> then be added to those directories etc etc. all the way down.
> >
> >
> > Yap.
> >
> >>
> >> > >
> >> > > It sounds complex :)
> >> >
> >> > Not really. The patch is not trivial, but the concept is simple.
> >> > If I find a few hours, I will post a demo.
> >>
> >> That would be cool! Always happy to test patches.
> >>
> >> > > > > > One more thing that could help said service is if overlayfs
> >> > > > > > supported a hybrid mode of redirect_dir=3Dfollow,metacopy=3D=
on,
> >> > > > > > where redirect is enabled for regular files for metacopy, bu=
t NOT
> >> > > > > > enabled for directories (which was redirect_dir original use=
 case).
> >> > > > > >
> >> > > > > > This way, the service could run the command line:
> >> > > > > > $ mv /ovl/blah/thing /ovl/local
> >> > > > > > then "mv" will get EXDEV for moving directories and will cre=
ate
> >> > > > > > opaque directories in their place and it will recursively mo=
ve all
> >> > > > > > the files to the opaque directories.
> >> > > > >
> >> > > > > Okay, I think I see what you are getting at but I need to test=
 the
> >> > > > > patch to make sure :)
> >> > >
> >> > > Sorry, I will try and test the patch this week as I am actually
> >> > > curious about using it to create offline handcrafted overlay trees
> >> > > too. So rather than run a combination of truncate, touch, chown,
> >> > > chmod, setfattr commands, mount an overlay with your patch, move t=
he
> >> > > dirs around, umount and then use the resulting metadata overlay as=
 a
> >> > > read-only overlay from then on.
> >> > >
> >> >
> >> > That sounds much better than mangling with overlayfs xattrs.
> >> >
> >> > > I'm still toying with the idea of creating one (enormous) read-onl=
y
> >> > > overlay with all the lib/plugin directories as opaque directories =
and
> >> > > just accepting that I might only refresh it once a day and clients
> >> > > might only remount it once a week... Not great, but some amount of
> >> > > local lookup acceleration is better than none.
> >> > >
> >> > > I think the main problem with using this patch for my use case is =
that
> >> > > as soon as you do the mv, you break any processes that might be
> >> > > scanning those dirs at that instant or any new ones that start up.=
 It
> >> > > may be possible to have my userspace daemon choose the right time =
to
> >> > > run the mv, but it's hard to predict how fast it would take to
> >> > > complete.
> >> > >
> >> >
> >> > Confused. I thought you were going to use the patch for offline prep=
aration
> >> > of metacopy layers.
> >>
> >> Sorry, I did mean only for the case where I might create the desired
> >> upper layer for reuse later on (ie offline changes), your patch sounds
> >> like a really useful and optimised time saver compared to my
> >> hand-crafted method. I am still considering the offline method if
> >> there proves to be no other alternative.
> >>
> >> But for the case where I would want a seamless online way to achieve
> >> the same upper layer opaque directories, then obviously moving
> >> directory trees even momentarily out of position and back again would
> >> likely break software just starting up in that moment.
> >>
> >> And coordinating a background daemon that does the mv, with users who
> >> randomly start applications sounds like a difficult problem.
> >>
> >> > Note that once you did mv into an opaque tree,
> >> > you can move the opaque dir back into its original location
> >> > (e.g. /blah/think/UUID...) and the dir will remain opaque,
> >> > because EXDEV is only generated when trying to move
> >> > merged dirs.
> >> > Moving opaque upper dirs around is allowed and should work.
> >>
> >> Yes exactly, this would likely work most of the time while online
> >> except when some software is expecting the files to always be located
> >> in an immutable path location and the mv is in progress? Unless I am
> >> totally misunderstanding (always a strong possibility).
> >
> >
> > You understood correctly.
> > This method is not suitable for online promotion.
> >
> >>
> >> Basically, I need to be able to continue serving the same files and
> >> paths even while the copy-up metadata process for any part of the tree
> >> is in progress. And it sounds like your idea of considering a copy-up
> >> of a merged dir as "complete" (and essentially opaque) would be the
> >> way to do that without files or dirs ever moving or losing access even
> >> momentarily.
> >
> >
> > Yes, that's the idea.
> >
> > I'll see when I get around to that demo.
>
> I found some time to write the POC patch, but not enough time
> to make it work :) - it is failing some fstests.
>
> Since I don't know when I will have time to debug the issues,
> here is the WIP if you want to debug it and point out the bugs:
>
> https://github.com/amir73il/linux/commits/ovl-finalize-dir/

This is very cool - many thanks!

Unfortunately, I'm probably not the right person to code and identify
actual fixes, but I can test and describe results pretty well. :)

So I applied the patch (cleanly) to v6.9.3 (because I had it handy)
and mounted with "metadata=3Don". The first oddity is that the root ovl
directory shows no results for "ls /ovl" (there are lots of dirs in
the lower layer)
but if I do the same to a directory I know exists, it appears and
returns results just fine (e.g. ls /ovl/thing/blah). Then if I "ls
/ovl" again I see just /ovl/thing but none of the other dirs (until
also accessed by path).

Anyway, that doesn't really block further testing as the software I
load does not need to walk or interrogate the entries. So then I did a
"chown -h -R bob /blah/thing/stuff/version" and looked at the xattrs
of the upper - all the (metadata) files and dirs were brought up with
files having a redirect, but the dirs that should have
trusted.overlay.opaque=3Dz did not at this stage. Another followup "ls
-lR  /blah/thing/stuff/version" and now I can see the
trusted.overlay.opaque=3Dz where I would expect it to be.

But now when I lookup random NOENT files in those directories, I can
still see the lookup going across the network to the lower filesystem?
It looks like it's the same for the positive lookups - doing a stat
against a file that I know is in a trusted.overlay.opaque=3Dz directory
still sends the lookup over NFS (which it does not if the directory is
opaque=3Dy).

I mean, I expect a lookup for an existing file with a metadata
redirect to it for reads but not metadata stat() lookups? Also I would
expect no lookups to the lower for negative lookups? Unless we can't
serve negative lookups from the readdir of the upper dir?

I have probably misunderstood that the "finalized" directories will
only serve the contents of the readdir result and not send metadata
lookups to the lower level (ala dir=3Dopaque). Or my v6.9.3 kernel has
some other issue unrelated to this patch....

Daire
