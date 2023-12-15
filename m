Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6600716419;
	Fri, 15 Dec 2023 08:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c1Pf9v7w"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-67f16446498so2975436d6.1;
        Fri, 15 Dec 2023 00:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702627246; x=1703232046; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZwWEE+lpAabb8z8cfDttB+OTV8KcDEdPLl6G0L8nRXo=;
        b=c1Pf9v7wzMKoMTs0qTNKsGpk5Arpa3Nu6jxugFSITKXzsIkoqACaqSXiBc6xGYatmH
         UnnPLEcj52BEjoW7hdt+6kKW+PDl90sqxvA2B1G+JUwoI7cEjBZKD4C1veWSHj9+SuzG
         hI2uUYV7Wh/WAnvrGR0mmnSOD5TEUpKLFYCI5EQDIS4XlC4j7jK6ZE/E3av4d5Ut5Swt
         Y0DJHPk9SWC55Zjg5gLISta8ux8jDPcNZawlDmIrGU+ogRkRQzScsFmBMkVb7K+bpwX5
         IsMUbNtBEVy/FJzsGluk+4KYJye/CCGmeDZMeYkwUcQCGusXccIERC8e69QCPmfpeGTH
         28Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702627246; x=1703232046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZwWEE+lpAabb8z8cfDttB+OTV8KcDEdPLl6G0L8nRXo=;
        b=JsjOwv4SRmHuaHPm/mPhyIuVI70IRht3MSBsjUIelJRMQ4Z/2weHS7ZDsSmpvzm4CE
         b061YyBDzi6lEKFEf63+Hl99qiDa5RsEmpmz1bFeNwrgNxtaQE9jU6Wn65owJyhNhO/H
         js9/dV5A8beW9xnCoCGehOsmULyeq2zKr+mTZjJi/yZQxWF80/2ih07kV6Shz+e7lb+T
         nkyoCbtbwEGrmkPZEphf/C53rmI9b022OaeZJ4tj5HKcfveRtObI7XStO0ng4FTkb/l1
         X/qvbZ0VedgyzOs4EujaGPOCD3fEqJtwAItFLkF8gI74fLiZv3YwSZWMZ8n2E6QyP4bP
         C86Q==
X-Gm-Message-State: AOJu0Yy3YrXlg565DPn+dTLExE1SrUKvx8cA0qoq6TH+2f54KsB3kOju
	QaN/7cttJ7yqOUNBMGZeNfHme9NtROJCdifdqGQxfF8zUgw=
X-Google-Smtp-Source: AGHT+IEIY6iZUm3ShKdZzaTYeVzgpYLD2c4584wf2vtKlpakjLX4m2HXYQc+73qUN+d/AdK0b1ukbiv9WcDyNEsGQO0=
X-Received: by 2002:ad4:4bd0:0:b0:67e:f9d2:daab with SMTP id
 l16-20020ad44bd0000000b0067ef9d2daabmr3755154qvw.130.1702627246086; Fri, 15
 Dec 2023 00:00:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231213123422.344600-3-amir73il@gmail.com> <c6c49fd7-2197-48b9-8203-ee5f4634b683@gmail.com>
In-Reply-To: <c6c49fd7-2197-48b9-8203-ee5f4634b683@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Dec 2023 10:00:34 +0200
Message-ID: <CAOQ4uxj_ikEdF-d3s_S7OGUDk1duUXzYqvB0BkyzFNgrCXYf=Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] overlayfs.rst: fix ReST formatting
To: Akira Yokosawa <akiyks@gmail.com>
Cc: bagasdotme@gmail.com, brauner@kernel.org, linux-doc@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023 at 4:07=E2=80=AFAM Akira Yokosawa <akiyks@gmail.com> w=
rote:
>
> Hi,
>
> On Wed, 13 Dec 2023 14:34:22 +0200, Amir Goldstein wrote:
> > Fix some indentation issues and fix missing newlines in quoted text
> > by converting quoted text to code blocks.
> >
> > Unindent a) b) enumerated list to workaround github displaying it
> > as numbered list.
>
> I don't think we need to work around github's weird behavior around
> enumerated lists.  What matters for us is what Sphinx (+ our own
> extensions) ends up generating.
>
> The corresponding html page rendered by Sphinx is at:
> https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html#permiss=
ion-model
>
> It does not look perfect, but at least it preserves enumeration by
> number and alphabet.
>

ok.

> I'd suggest reporting github about the minor breakage of their
> rst renderer.
>
> Further comments below:
>
> >
> > Reported-by: Christian Brauner <brauner@kernel.org>
> > Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  Documentation/filesystems/overlayfs.rst | 63 +++++++++++++------------
> >  1 file changed, 32 insertions(+), 31 deletions(-)
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/fi=
lesystems/overlayfs.rst
> > index 926396fdc5eb..a36f3a2a2d4b 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -118,7 +118,7 @@ Where both upper and lower objects are directories,=
 a merged directory
> >  is formed.
> >
> >  At mount time, the two directories given as mount options "lowerdir" a=
nd
> > -"upperdir" are combined into a merged directory:
> > +"upperdir" are combined into a merged directory::
> >
> >    mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,\
> >    workdir=3D/work /merged
> > @@ -174,10 +174,10 @@ programs.
> >  seek offsets are assigned sequentially when the directories are read.
> >  Thus if
> >
> > -  - read part of a directory
> > -  - remember an offset, and close the directory
> > -  - re-open the directory some time later
> > -  - seek to the remembered offset
> > +- read part of a directory
> > +- remember an offset, and close the directory
> > +- re-open the directory some time later
> > +- seek to the remembered offset
>
> To my eyes, unindent spoils the readability of this file as pure
> plain text.  Please don't do this.
>

Ok. I see what you mean.
I restored a single space indent.
I don't see why double space is called for and it is inconsistent
with indentation in the rest of the doc.

> >
> >  there may be little correlation between the old and new locations in
> >  the list of filenames, particularly if anything has changed in the
> > @@ -285,21 +285,21 @@ Permission model
> >
> >  Permission checking in the overlay filesystem follows these principles=
:
> >
> > - 1) permission check SHOULD return the same result before and after co=
py up
> > +1) permission check SHOULD return the same result before and after cop=
y up
> >
> > - 2) task creating the overlay mount MUST NOT gain additional privilege=
s
> > +2) task creating the overlay mount MUST NOT gain additional privileges
> >
> > - 3) non-mounting task MAY gain additional privileges through the overl=
ay,
> > - compared to direct access on underlying lower or upper filesystems
> > +3) non-mounting task MAY gain additional privileges through the overla=
y,
> > +   compared to direct access on underlying lower or upper filesystems
>
> All you need to fix is this adjustment of indent.
> Don't do other unindents please
>

OK. I also fixed the same indents in "Non-standard behavior".

> >
> > -This is achieved by performing two permission checks on each access
> > +This is achieved by performing two permission checks on each access:
> >
> > - a) check if current task is allowed access based on local DAC (owner,
> > -    group, mode and posix acl), as well as MAC checks
> > +a) check if current task is allowed access based on local DAC (owner,
> > +group, mode and posix acl), as well as MAC checks
> >
> > - b) check if mounting task would be allowed real operation on lower or
> > -    upper layer based on underlying filesystem permissions, again incl=
uding
> > -    MAC checks
> > +b) check if mounting task would be allowed real operation on lower or
> > +upper layer based on underlying filesystem permissions, again includin=
g
> > +MAC checks
>
> Your workaround harms the readability very badly.
> Don't break the construct of enumerated (or numbered) list in rst.
>

ok.

> For the specification of enumerated list, please see:
>
> https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#enumer=
ated-lists
>
> If there is a rst parser who fails to recognize some of the defined
> list structure, fix such a parser please!
>
> >
> >  Check (a) ensures consistency (1) since owner, group, mode and posix a=
cls
> >  are copied up.  On the other hand it can result in server enforced
> > @@ -311,11 +311,11 @@ to create setups where the consistency rule (1) d=
oes not hold; normally,
> >  however, the mounting task will have sufficient privileges to perform =
all
> >  operations.
> >
> > -Another way to demonstrate this model is drawing parallels between
> > +Another way to demonstrate this model is drawing parallels between::
> >
> >    mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,... /=
merged
> >
> > -and
> > +and::
> >
> >    cp -a /lower /upper
> >    mount --bind /upper /merged
> > @@ -328,7 +328,7 @@ Multiple lower layers
> >  ---------------------
> >
> >  Multiple lower layers can now be given using the colon (":") as a
> > -separator character between the directory names.  For example:
> > +separator character between the directory names.  For example::
> >
> >    mount -t overlay overlay -olowerdir=3D/lower1:/lower2:/lower3 /merge=
d
> >
> > @@ -340,13 +340,13 @@ rightmost one and going left.  In the above examp=
le lower1 will be the
> >  top, lower2 the middle and lower3 the bottom layer.
> >
> >  Note: directory names containing colons can be provided as lower layer=
 by
> > -escaping the colons with a single backslash.  For example:
> > +escaping the colons with a single backslash.  For example::
> >
> >    mount -t overlay overlay -olowerdir=3D/a\:lower\:\:dir /merged
> >
> >  Since kernel version v6.8, directory names containing colons can also
> >  be configured as lower layer using the "lowerdir+" mount options and t=
he
> > -fsconfig syscall from new mount api.  For example:
> > +fsconfig syscall from new mount api.  For example::
> >
> >    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/a:lower::dir", 0=
);
> >
> > @@ -390,11 +390,11 @@ Data-only lower layers
> >  With "metacopy" feature enabled, an overlayfs regular file may be a co=
mposition
> >  of information from up to three different layers:
> >
> > - 1) metadata from a file in the upper layer
> > +1) metadata from a file in the upper layer
> >
> > - 2) st_ino and st_dev object identifier from a file in a lower layer
> > +2) st_ino and st_dev object identifier from a file in a lower layer
> >
> > - 3) data from a file in another lower layer (further below)
> > +3) data from a file in another lower layer (further below)
>
> Ditto.
>
> >
> >  The "lower data" file can be on any lower layer, except from the top m=
ost
> >  lower layer.
> > @@ -405,7 +405,7 @@ A normal lower layer is not allowed to be below a d=
ata-only layer, so single
> >  colon separators are not allowed to the right of double colon ("::") s=
eparators.
> >
> >
> > -For example:
> > +For example::
> >
> >    mount -t overlay overlay -olowerdir=3D/l1:/l2:/l3::/do1::/do2 /merge=
d
> >
> > @@ -419,7 +419,7 @@ to the absolute path of the "lower data" file in th=
e "data-only" lower layer.
> >
> >  Since kernel version v6.8, "data-only" lower layers can also be added =
using
> >  the "datadir+" mount options and the fsconfig syscall from new mount a=
pi.
> > -For example:
> > +For example::
> >
> >    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
> >    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
> > @@ -429,7 +429,7 @@ For example:
> >
> >
> >  fs-verity support
> > -----------------------
> > +-----------------
> >
> >  During metadata copy up of a lower file, if the source file has
> >  fs-verity enabled and overlay verity support is enabled, then the
> > @@ -653,9 +653,10 @@ following rules apply:
> >     encode an upper file handle from upper inode
> >
> >  The encoded overlay file handle includes:
> > - - Header including path type information (e.g. lower/upper)
> > - - UUID of the underlying filesystem
> > - - Underlying filesystem encoding of underlying inode
> > +
> > +- Header including path type information (e.g. lower/upper)
> > +- UUID of the underlying filesystem
> > +- Underlying filesystem encoding of underlying inode
>
> Ditto.
>

ok, but inconsistent indentation between numbered and bullet list is
also not nice:
https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html#nfs-expor=
t

so I kept this indent and I also indented the non-indented numbered lists
in this section to conform to the rest of the numbered lists in this doc.

I've pushed the fixes to overlayfs-next.
Kept RVB from Bagas, because your comment about the unindent is
aligned with Bagas' initial review comment.

Thanks,
Amir.
