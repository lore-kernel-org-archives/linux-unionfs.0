Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE52A1BBBE0
	for <linux-unionfs@vger.kernel.org>; Tue,  6 Aug 2024 07:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722930977; cv=none; b=Tky3vTAWwmmLcQ8UxbhfmZRDmm2OH72j6oU2Rl6894hkSJ7roj7f6vLV2VAszMSx6Wc4WhHmmaQ+e2LBOFnDn4xUMUT4mO00nbU4qkXrMlGWUvt5b3661X2Mz8NaJNw/YNZxCNPihJ82uws4rlD/12MZHpl5qs0jIlX8ABCe38I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722930977; c=relaxed/simple;
	bh=87h7XivvPLFmwGy6HOTatCGU/RATQxtiq4JxswK3+f8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fazeUL0GkFs/i2oBht9yW6PqpQ9HLhNiRZ29tiVmQgDFk1SYo+dUVXpfpyMZMq+gGnaKegikps1JzKbQpQSrFgoqFtu1Se3L4PRPovguMcEWT8yhoMSAq4/tXl7x569WE4VeODNBkiLbtrwr/Drb4OBgZiiCy+jaXLHg7zaiJZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bQtY5Hwh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bQtY5Hwh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722930973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QX514vaAYximOZGXm5H8QvG0Kf1JJvpTnbSOXC53vUM=;
	b=bQtY5HwhQL8DFVKE4ROorNYLvLwNPOoIWZ/iHC1+tURP6x524onB9z9heTjQaPvse1augi
	EwaZ2cVGkNZ89h/JpFYUZpVsP9cAkpAqG5AIRcM4wqBx1qkA+myIY7kaiHvir/4sTzdbFC
	GisNBMbHe/MY/6DjYQmQzdfKYLXoMa0=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-mf9p-6KuPtW-BI_NwS9nBw-1; Tue, 06 Aug 2024 03:56:12 -0400
X-MC-Unique: mf9p-6KuPtW-BI_NwS9nBw-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-39b3cd1813aso5635605ab.0
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Aug 2024 00:56:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722930972; x=1723535772;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QX514vaAYximOZGXm5H8QvG0Kf1JJvpTnbSOXC53vUM=;
        b=nbzEBUuc9R5+1ghShauu7Gy0awVUmOd5KlH2eJaXTH8XynvdrcDV0oWV5PPyD6wsy6
         CRE+21s3XdrYmeB9Y0D/BjNnOKacS7iXy0G4jkX5rW4ZgajSlq1uvlDeQu0ElYCqXhtV
         mGf3EZ/S0eiAPj0WB8NdxAu8u5y6BxhOSVjuM++ISnqFcJIWxBRaW1x+8zFE5cOXEDd4
         mA5AfjDj0YI5214GDQP9Sp7KBgLDDOjhhcMdl6UAFB8JUsKg2sXt1SCQQSdvxk8rmX7A
         QMaIE3R7/iwy4x66gERxVSEVwEKP2wx5hkUt4xoBwFQZzRVDWmHnWE88XVCAo0bzYp90
         +XTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHEsbIDELtnJhAtbNuT/iuPWzX+FPuiz5+W9WdvDFeSJlBi1IvsC0426nhFiBRpg9lfkEdKlvVKa3WFG9uTNvbvRSbXlD0AB/sMM0jiw==
X-Gm-Message-State: AOJu0Yz6u04H8GHqjx1iAKx1CR29g21wpk7o2KUj8aO7qEUU17tfMRIJ
	QT5Nb/h7wtP2Y2DJfq5uizerq1wD2WcYVkqcc8v7x0PTzIGwwJFwpk3JMgdfryKOuvm6moXCCQg
	vrFnrApj2PiT/qYDkevNZIPX70LSe4tzZV67fz0EXN1vLHLk+UsahRzZUA9XUer2roUQaCks3Wq
	CYd0pC32H3J0LeGf5SwvMbAYtGyVKQ7ssfHY8oaI58h0S2GQ==
X-Received: by 2002:a92:d212:0:b0:375:ae6b:9d92 with SMTP id e9e14a558f8ab-39b1fba1668mr165078875ab.12.1722930971557;
        Tue, 06 Aug 2024 00:56:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfqgXLBoe3i2nMp2K787fqm/kCT31keCJEmscJp/9wIY9WwrIGSL/tPLgSP8sWM7qj4GpSrN+2ABvkULFxSsc=
X-Received: by 2002:a92:d212:0:b0:375:ae6b:9d92 with SMTP id
 e9e14a558f8ab-39b1fba1668mr165078695ab.12.1722930971086; Tue, 06 Aug 2024
 00:56:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
 <f1ed1b60-273d-4ee6-bbcb-ae3d78486b70@mbaynton.com> <CAOQ4uxiSm0Le4dYx_R2WPmF9Ut8z6eZinN-qvDrG+Y2GnX11fg@mail.gmail.com>
 <9237a062-4f91-4d32-be19-b7bdd7d71bfe@mbaynton.com> <CAOQ4uxhMbzvmoYS1x0DdaNm+BvkQ7+7mdmsA2XpiVXGO2Fgvbg@mail.gmail.com>
 <91e8c240-ed60-40ab-8c55-f06347e26841@mbaynton.com> <CAOQ4uxix_E6mthejJ89O6ipfQBH8YJhXZpNLR1yeKuUCx_=Tog@mail.gmail.com>
In-Reply-To: <CAOQ4uxix_E6mthejJ89O6ipfQBH8YJhXZpNLR1yeKuUCx_=Tog@mail.gmail.com>
From: Alexander Larsson <alexl@redhat.com>
Date: Tue, 6 Aug 2024 09:55:59 +0200
Message-ID: <CAL7ro1G10j1_nL7hbX149YEd=daqXKwncMbzXyvyiJKB1Ko5Bg@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>
Cc: Mike Baynton <mike@mbaynton.com>, Daire Byrne <daire@dneg.com>, 
	overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 9:29=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Sun, Jul 28, 2024 at 11:33=E2=80=AFPM Mike Baynton <mike@mbaynton.com>=
 wrote:
> >
> > On 7/21/24 22:31, Amir Goldstein wrote:
> > >
> > >
> > > On Mon, Jul 22, 2024, 6:02=E2=80=AFAM Mike Baynton <mike@mbaynton.com
> > > <mailto:mike@mbaynton.com>> wrote:
> > >
> > > On 7/12/24 04:09, Amir Goldstein wrote:
> > >> On Fri, Jul 12, 2024 at 6:24=E2=80=AFAM Mike Baynton <mike@mbaynton.=
com
> > > <mailto:mike@mbaynton.com>> wrote:
> > >>>
> > >>> On 7/11/24 18:30, Amir Goldstein wrote:
> > >>>> On Thu, Jul 11, 2024 at 6:59=E2=80=AFPM Daire Byrne <daire@dneg.co=
m
> > > <mailto:daire@dneg.com>> wrote:
> > >>>>> Basically I have a read-only NFS filesystem with software
> > >>>>> releases that are versioned such that no files are ever
> > >>>>> overwritten or
> > > changed.
> > >>>>> New uniquely named directory trees and files are added from
> > >>>>> time to time and older ones are cleaned up.
> > >>>>>
> > >>>>
> > >>>> Sounds like a common use case that many people are interested
> > >>>> in.
> > >>>
> > >>> I can vouch that that's accurate, I'm doing nearly the same
> > > thing. The
> > >>> properties of the NFS filesystem in terms of what is and is not
> > > expected
> > >>> to change is identical for me, though my approach to
> > >>> incorporating overlayfs has been a little different.
> > >>>
> > >>> My confidence in the reliability of what I'm doing is still far
> > >>> from absolute, so I will be interested in efforts to
> > >>> validate/officially sanction/support/document related
> > >>> techniques.
> > >>>
> > >>> The way I am doing it is with NFS as a data-only layer.
> > >>> Basically
> > > my use
> > >>> case calls for presenting different views of NFS-backed data
> > >>> (it's software libraries) to different applications. No
> > >>> application
> > > wants or
> > >>> needs to have the entire NFS tree exposed to it, but each
> > >>> application wants to use some data available on NFS and wants it
> > >>> to be
> > > presented in
> > >>> some particular local place. So I actually wanted a method where
> > >>> I author a metadata-only layer external to overlayfs, built to
> > >>> spec.
> > >>>
> > >>> Essentially it's making overlayfs redirects be my symlinks so
> > > that code
> > >>> which doesn't follow symlinks or is otherwise influenced by them
> > > is none
> > >>> the wiser.
> > >>>
> > >>
> > >> Nice. I've always wished that data-only would not be an
> > >> "offline-only"
> > > feature,
> > >> but getting the official API for that scheme right might be a
> > > challenge.
> > >>
> > >>>>> My first question is how bad can the "undefined behaviour"
> > >>>>> be
> > > in this
> > >>>>> kind of setup?
> > >>>>
> > >>>> The behavior is "undefined" because nobody tried to define it,
> > >>>> document it and test it. I don't think it would be that "bad",
> > >>>> but it will be unpredictable and is not very nice for a
> > >>>> software product.
> > >>>>
> > >>>> One of the current problems is that overlayfs uses readdir
> > >>>> cache the readdir cache is not auto invalidated when lower dir
> > >>>> changes so whether or not new subdirs are observed in overlay
> > >>>> depends on whether the merged overlay directory is kept in
> > >>>> cache or not.
> > >>>>
> > >>>
> > >>> My approach doesn't support adding new files from the data-only
> > >>> NFS layer after the overlayfs is created, of course, since the
> > > metadata-only
> > >>> layer is itself the first lower layer and so would presumably
> > >>> get
> > > into
> > >>> undefined-land if added to. But this arrangement does probably
> > >>> mitigate this problem. Creating metadata inodes of a fixed set
> > >>> of libraries for a specific application is cheap enough (and
> > > considerably
> > >>> faster than copying it all locally) that the immutablity
> > >>> limitation works for me.
> > >>>
> > >>
> > >> Assuming that this "effectively-data-only" NFS layer is never
> > > iterated via
> > >> overlayfs then adding new unreferenced objects to this layer
> > > should not
> > >> be a problem either.
> > >>
> > >>>>> Any files that get copied up to the upper layer are
> > >>>>> guaranteed to never change in the lower NFS filesystem (by
> > >>>>> it's design), but new directories and files that have not yet
> > >>>>> been
> > > copied
> > >>>>> up, can randomly appear over time. Deletions are not so
> > >>>>> important because if it has been deleted in the lower level,
> > >>>>> then the upper level copy failing has similar results (but we
> > >>>>> should cleanup the upper layer too).
> > >>>>>
> > >>>>> If it's possible to get over this first difficult hurdle,
> > >>>>> then
> > > I have
> > >>>>> another extra bit of complexity to throw on top - now
> > >>>>> manually
> > > make an
> > >>>>> entire directory tree (of metdata) that we have recursively
> > > copied up
> > >>>>> "opaque" in the upper layer (currently needs to be done
> > >>>>> outside of overlayfs). Over time or dropping of caches, I
> > >>>>> have found that this (seamlessly?) takes effect for new
> > >>>>> lookups.
> > >>>>>
> > >>>>> I also noticed that in the current implementation, this
> > >>>>> "opaque" transition actual breaks access to the file because
> > >>>>> the metadata copy-up sets "trusted.overlay.metacopy" but does
> > >>>>> not currently
> > > add an
> > >>>>> explicit "trusted.overlay.redirect" to the correspnding lower
> > >>>>> layer file. But if it did (or we do it manually with
> > >>>>> setfattr), then
> > > it is
> > >>>>> possible to have an upper level directory that is opaque,
> > >>>>> contains file metadata only and redirects to the data to the
> > >>>>> real files
> > > on the
> > >>>>> lower NFS filesystem.
> > >>>
> > >>> So once you use opaque dirs and redirects on an upper layer,
> > >>> it's sounding very similar to redirects into a data-only layer.
> > >>> In either case you're responsible for producing metadata inodes
> > >>> for each
> > > NFS file
> > >>> you want presented to the application/user.
> > >>>
> > >>
> > >> Yes, it is almost the same as data-only layer. The only difference
> > >> is that real data-only layer can never be accessed directly from
> > >> overlay, while the effectively-data-only layer must have some path
> > >> (e.g /blobs) accessible directly from overlay in order to do online
> > >> rename of blobs into the upper opaque layer.
> > >>
> > >>> This way seems interesting and more promising for adding
> > >>> NFS-backed files "online" though.
> > >>>
> > >>>> how can we document it to make the behavior "defined"?
> > >>>>
> > >>>> My thinking is:
> > >>>>
> > >>>> "Changes to the underlying filesystems while part of a mounted
> > > overlay
> > >>>> filesystem are not allowed.  If the underlying filesystem is
> > > changed,
> > >>>> the behavior of the overlay is undefined, though it will not
> > > result in
> > >>>> a crash or deadlock.
> > >>>>
> > >>>> One exception to this rule is changes to underlying filesystem
> > > objects
> > >>>> that were not accessed by a overlayfs prior to the change. In
> > >>>> other words, once accessed from a mounted overlay filesystem,
> > >>>> changes to the underlying filesystem objects are not allowed."
> > >>>>
> > >>>> But this claim needs to be proved and tested (write tests),
> > >>>> before the documentation defines this behavior. I am not even
> > >>>> sure if the claim is correct.
> > >>>
> > >>> I've been blissfully and naively assuming that it is based on
> > > intuition
> > >>> :).
> > >>
> > >> Yes, what overlay did not observe, overlay cannot know about. But
> > >> the devil is in the details, such as what is an "accessed
> > >> filesystem object".
> > >>
> > >> In our case study, we refer to the newly added directory entries
> > >> and new inodes "never accessed by overlayfs", so it sounds safe to
> > >> add them while overlayfs is mounted, but their parent
> > > directory,
> > >> even if never iterated via overlayfs was indeed accessed by
> > >> overlayfs (when looking up for existing siblings), so overlayfs did
> > >> access the lower parent directory and it does reference the lower
> > >> parent directory dentry/inode, so it is still not "intuitively"
> > >> safe to
> > > change it.
> >
> > This makes sense. I've been sure to cause the directory in the data-onl=
y
> > layer that subsequently experiences an "append" to be consulted to
> > lookup a different file before the append.
> >
> > >>
> > >>>
> > >>> I think Daire and I are basically only adding new files to the
> > >>> NFS filesystem, and both the all-opaque approach and the
> > >>> data-only
> > > approach
> > >>> could prevent accidental access to things on the NFS filesystem
> > > through
> > >>> the overlayfs (or at least portion of it meant for end-user
> > > consumption)
> > >>> while they are still being birthed and might be experiencing
> > >>> changes. At some point in the NFS tree, directories must be
> > >>> modified, but
> > > since
> > >>> both approaches have overlayfs sourcing all directory entries
> > > from local
> > >>> metadata-only layers, it seems plausible that the directories
> > >>> that change aren't really "accessed by a overlayfs prior to the
> > >>> change."
> > >>>
> > >>> How much proving/testing would you want to see before
> > >>> documenting
> > > this
> > >>> and supporting someone in future who finds a way to prove the
> > >>> claim wrong?
> > >>>
> > >>
> > >> *very* good question :)
> > >>
> > >> For testing, an xfstest will do - you can fork one of the existing
> > >> data-only tests as a template>
> > > Due to the extended delay in a substantive response, I just wanted
> > > to send a quick thank you for your reply and suggestions here. I am
> > > still interested in pursuing this, but I have been busy and then
> > > recovering from illness.
> > >
> > > I'll need to study how xfstest directly exercises overlayfs and how
> > > it is combined with unionmount-testsuite I think.
> > >
> > >
> > > Running unionmount-testsuite from fstests is optional not a must for
> > > developing an fastest.
> > >
> > > See README.overlay in fstests for quick start With testing overlays.
> > >
> > > Thanks, Amir.
> > >
> > >
> > >>
> > >> For documentation, I think it is too hard to commit to the general
> > >> statement above.
> > >>
> > >> Try to narrow the exception to the rule to the very specific use
> > >> case of "append-only" instead of "immutable" lower directory and
> > >> then state that the behavior is "defined" - the new entries are
> > >> either
> > > visible
> > >> by overlayfs or they are not visible, and the "undefined" element
> > >> is *when* they become visible and via which API (*).
> > >>
> > >> (*) New entries may be visible to lookup and invisible to readdir
> > >> due to overlayfs readdir cache, and entries could be visible to
> > >> readdir and invisible to lookup, due to vfs negative lookup
> > > cache.
> >
> > So I've gotten a test going that focuses on really just two behaviors
> > that would satisfy my use case and that seem to currently be true.
> > Tightening the claims to a few narrow -- and hopefully thus needing
> > little to no effort to support -- statements seems like a good idea to
> > me, though in thinking through my use case, the behaviors I attempt to
> > make defined are a little different from how I read the idea above. Tha=
t
> > seems to be inclusive of regular lower layers, where files might or
> > might not be accessible through regular merge. It looks like your
> > finalize patch is more oriented towards establishing useful defined
> > behaviors in case of modifications to regular lower layers, as well as
> > general performance. I thought I could probably go even simpler.
> >
> > Because I simply want to add new software versions to the big underlyin=
g
> > data-only filesystem periodically but am happy to create new overlayfs
> > mounts complete with new "middle"/"redirect" layers to the new versions=
,
> > I just focus on establishing the safety of append-only additions to a
> > data-only layer that's part of a mounted overlayfs.
> > The only real things I need defined are that appending a file to the
> > data-only layer does not create undefined behavior in the existing
> > overlayfs, and that the newly appended file is fully accessible for
> > iteration and lookup in a new overlayfs, regardless of the file access
> > patterns through any overlayfs that uses the data-only filesystem as a
> > data-only layer.
> >
> > The defined behaviors are:
> >  * A file added to a data-only layer while mounted will not appear in
> >    the overlayfs via readdir or lookup, but it is safe for applications
> >    to attempt to do so.
> >  * A subsequently mounted overlayfs that includes redirects to the adde=
d
> >    files will be able to iterate and open the added files.
> >
> > So the test is my attempt to create the least favorable conditions /
> > most likely conditions to break the defined behaviors. Of course testin=
g
> > for "lack of undefined" behavior is open-ended in some sense. The test
> > conforms to the tightly defined write patterns, but since we don't
> > restrict the read patterns against overlayfs there might be other
> > interesting cases to validate there.
>
> This feels like a good practical approach.
>
> As I wrote in comment on your test patch, this is behavior how all data-o=
nly
> overlayfs works, because the data-only layer is always going to be a laye=
r
> that is shared among many overlayfs, so at any given time, there would be
> an online overlayfs when blobs are added to the data-only layer to compos=
e
> new images.
>
> It is good to make this behavior known and explicit - I am just saying
> that it is implied by the data-only layers features, because it would
> have been useless otherwise.

I agree that it is nice to have this be explicit, clearly e.g.
composefs (at least the expected usecase of it) would need this. I
never even considered that this would not be the case though, as why
would separate mounts affect each other.


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

