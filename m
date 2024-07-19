Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF4BB647
	for <linux-unionfs@vger.kernel.org>; Fri, 19 Jul 2024 09:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721380763; cv=none; b=MVoDpurwmTa3s37CjuyDFJRWSF7zLwpz+XduVVKWEKccA9AaPiOizrMNpJdIxZtTnee1tKpmYCylS6M2cjkZso1WqEAW33UMmee3q9Ms7QPtc18GaPSIaSu1hfbzgV6VQTKfRg6yBHApbQJAi9OHD/JnMZDk1DH2H0hOIpPut84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721380763; c=relaxed/simple;
	bh=mBmhJdkcvMG5JP5yTV52OYXoK+Uf6Nqzy01wyt3ttW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TiDmuFfmqv1i6HBqcdwOFQiYISzcQTC42bB+wZqVToN+8hk2dHV2dt2Fl0j3kn0yWFO8GZl2ds2Mjt07zLw+Pv+tZYbNaankKe949mPBBz2I8n030quTqj9c54o3eijsXNCEhKSCx7fqmUrdi3AMwa1C2E5in7FPUzIc0N5ZsIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WrjMz4JL; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WrjMz4JL"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-79f15e7c89cso86102185a.1
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Jul 2024 02:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721380761; x=1721985561; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8cps/xWbyKgAQwD2sZtMTby62jxc0YG0UDhKr5QEJPc=;
        b=WrjMz4JLKl+PkKQN0MhKR4MMe+hQvqLBU4VNlkWRF0fpMchj9j0tqAIFg9tDZnNyME
         XLDjG7/pelqwF6PpOPvbp43E88VrXne2MSJytwCe/MpPLCAY2wFncHiYi0hLOA1CTUBJ
         LUeB4Ju1cFotigvXsbpAP9OYCqvU/wtR1vijWw4Fnv+51u+y3Jf5djoaATBRHBdojN80
         2/JCXI5ahelxCjXTpHTbumkX6MqujYLsxtrcs81asN9SM7qmz9NAmAVE7fx5nsZFWL/3
         vI8SvoeAIoqnfpDUiz591zyTHfbX1+YgZWngQ5U1v6oBg6BVJHot+4IWs23CovouKBlJ
         s/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721380761; x=1721985561;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8cps/xWbyKgAQwD2sZtMTby62jxc0YG0UDhKr5QEJPc=;
        b=kY0MUzqHYZWfp1oiKhf/Hjs6lcY9xTMiiZ4+RmMt7p5c2f1YIOTaRXOUD27v/KqjOD
         z6dc0k4KfW5EYzUZdmZE/laoeACcvGe3dwSUb+LIYkCZnhMn04rPMtbQGWDlFqb7JdC/
         GzKmmWgQ0GADO1CQPw0xEQ5iNKmUBWBeGBJpWjKLweZqKjeUeKMVa9BcAzWeSzXsb3mC
         cGTGaR9kKi23u20k59cM8Y+MF178+zwzSEV1f47zpWzt4CSUH66CJ480YN/yd/snxf5O
         GPIEP9yYFRvzaHrorGhY46CQBgjvc5EAL3fvEkdHsss/MjJi0opXdxohG8DhsJQuDvUm
         uDDA==
X-Gm-Message-State: AOJu0YxFwB3xzuPohnCJHB+NYEb/zMrYWKN0zWANYbU7baPxSDpHBMht
	r1QT5a1vd8D4T+DcfHwcm6nGCFRquMBp2+rlqn2D1cDQvqO/PIZ3KTmIQ0hYEzG/1U2O4+ytYZu
	af2a/TpYhNmAjPdKwgbYiwxOVcsPWEomom5o=
X-Google-Smtp-Source: AGHT+IEcML/1A4Av6DIW4Qgue9VPMLz7anXI0ZNR/06R54mK0bW9aLSP2emjFWR2ZMJRwE0epODG9Ux4I9U8+6OkpCQ=
X-Received: by 2002:a05:620a:1a22:b0:79f:1105:bfe with SMTP id
 af79cd13be357-7a1938c45c4mr369595485a.1.1721380760923; Fri, 19 Jul 2024
 02:19:20 -0700 (PDT)
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
 <CAOQ4uxhO21UqcppSqoXO7QLOUAHVjRGkN1Ao=WrNGCc7GHaD6w@mail.gmail.com>
 <CAOQ4uxjAG_mcZBZ=Yi7i2zVjizEEGiw7mAfM9wu23KqBAGSnug@mail.gmail.com> <CAPt2mGNdNtSFQchwCFD9r1cDa4URJ7BVF7HwuzQUCp2qK30shw@mail.gmail.com>
In-Reply-To: <CAPt2mGNdNtSFQchwCFD9r1cDa4URJ7BVF7HwuzQUCp2qK30shw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 19 Jul 2024 12:19:08 +0300
Message-ID: <CAOQ4uxgJwoudXw9pMw9nz5d5SCuryxv-O9fpnRcPcwqg4nk1hw@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Daire Byrne <daire@dneg.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Mike Baynton <mike@mbaynton.com>
Content-Type: text/plain; charset="UTF-8"

> > >> Basically, I need to be able to continue serving the same files and
> > >> paths even while the copy-up metadata process for any part of the tree
> > >> is in progress. And it sounds like your idea of considering a copy-up
> > >> of a merged dir as "complete" (and essentially opaque) would be the
> > >> way to do that without files or dirs ever moving or losing access even
> > >> momentarily.
> > >
> > >
> > > Yes, that's the idea.
> > >
> > > I'll see when I get around to that demo.
> >
> > I found some time to write the POC patch, but not enough time
> > to make it work :) - it is failing some fstests.
> >
> > Since I don't know when I will have time to debug the issues,
> > here is the WIP if you want to debug it and point out the bugs:
> >
> > https://github.com/amir73il/linux/commits/ovl-finalize-dir/
>
> This is very cool - many thanks!
>

Pushed two fixes to this branch - now it passes fstest - please re-test.

> Unfortunately, I'm probably not the right person to code and identify
> actual fixes, but I can test and describe results pretty well. :)
>

Your detailed description lead me straight to the bugs :)

> So I applied the patch (cleanly) to v6.9.3 (because I had it handy)
> and mounted with "metadata=on". The first oddity is that the root ovl
> directory shows no results for "ls /ovl" (there are lots of dirs in
> the lower layer)

Was a silly bug - failure to initialize root dentry correctly.
It was also observed by several fstests that now pass.

> but if I do the same to a directory I know exists, it appears and
> returns results just fine (e.g. ls /ovl/thing/blah). Then if I "ls
> /ovl" again I see just /ovl/thing but none of the other dirs (until
> also accessed by path).
>
> Anyway, that doesn't really block further testing as the software I
> load does not need to walk or interrogate the entries. So then I did a
> "chown -h -R bob /blah/thing/stuff/version" and looked at the xattrs
> of the upper - all the (metadata) files and dirs were brought up with
> files having a redirect, but the dirs that should have
> trusted.overlay.opaque=z did not at this stage. Another followup "ls
> -lR  /blah/thing/stuff/version" and now I can see the
> trusted.overlay.opaque=z where I would expect it to be.
>
> But now when I lookup random NOENT files in those directories, I can
> still see the lookup going across the network to the lower filesystem?

Second silly bug.

> It looks like it's the same for the positive lookups - doing a stat
> against a file that I know is in a trusted.overlay.opaque=z directory
> still sends the lookup over NFS (which it does not if the directory is
> opaque=y).
>
> I mean, I expect a lookup for an existing file with a metadata
> redirect to it for reads but not metadata stat() lookups? Also I would

ovl will lookup the lower data of a metacopy file at lookup time.
Perhaps we could do lazy lookup of data files, like we do with
data-only layers, but this would be more complicated and in any
case, stat(2) needs the lower data file to present the correct
value of st_blocks.

IOW, this patch mainly helps to prevent *negative* lookups
in the lower layers.

> expect no lookups to the lower for negative lookups? Unless we can't
> serve negative lookups from the readdir of the upper dir?

Correct expectation.
The bug was fixed. It should hopefully work now,
although I did not test.

>
> I have probably misunderstood that the "finalized" directories will
> only serve the contents of the readdir result and not send metadata
> lookups to the lower level (ala dir=opaque). Or my v6.9.3 kernel has
> some other issue unrelated to this patch....

You understood almost correctly, but you need to understand that
the finalized directory is not completely opaque, it is partly opaque.
You can visualize this as painting the space "between entries" opaque,
so that negative lookup results will stop as well as readdir, but ovl
will still look *underneath* entries.

BTW, ovl will also lookup in lower dirs if entries inside an upper
opaque dir have an absolute path redirect xattr.
This type of upper opaque dir is also called "impure" and has an
"impure" xattr.

So you may say that the difference between an opaque=y
dir and opaque=z dir is that in the latter, all entries are treated
as if they have an absolute path redirect (to their own path),
but that is a very hand wavy way of putting it.

Anyway, if you are happy with the patch and want to see it upstreamed,
I have few requests:

1. Please provide your Tested-by.
2. Please provide a detailed cover letter that explains the problem (*)
    and how the patch fixes it, which includes performance gain numbers.
    You may post the cover letter with my patch or ask me to do it
3. Please write an fstest to test the finalized dir feature (**)
    You may want to look at test overlay/031 for inspiration
    if also makes changes to layers offline and examines the outcome

(*) Please do NOT include the story of changing lower entries
    under a mounted overlayfs - they are not relevant to this patch
    and they are very controversial.
(**) Basically do chown -R and ls, unmount overlay, add lower entry
    re-mount overlay and verify that it is not observed.
    Can also sanity check that opaque=z was set.
    Note that adding lower entries offline is a behavior that was once allowed
    and some users actually expect it to work, so I made the feature
    depend on !ovl_allow_offline_changes(ofs).
    Therefore, the test should explicitly require and enable metacopy for
    overlayfs mount to enable the finalized dir feature.

Thanks,
Amir.
