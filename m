Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002C81A5B0;
	Fri, 15 Dec 2023 10:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y9uaEZ5H"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-77f44cd99c6so37563985a.0;
        Fri, 15 Dec 2023 02:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702636368; x=1703241168; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gb/T/oASgtKNv+0xZI+c0KBr6jni4i5H3ET7iArrf4k=;
        b=Y9uaEZ5Hxo7SD6XcKNmcoCdqvCusvG6qDbFQB67m5pXxLi2T5o78xaSfCfzSGOKvC2
         MUWgaALOa5BSeyCrHeK7U/4PN8N4LZNW4/AQSn+xvQEStplJULfOlZRoaTQ99+LJK15G
         vVnrF79UYHmnnDTyCwUPOKnSHz9Sk016Zur/Zm9P8EYBdrpWVbInU4rgq++xyFEW39x/
         kSkkpETO0dptP4pFSD15No6dG8CLan+jC91Kul74jzaaaKjztERflHAH7HscW04N8mgZ
         kdNdR8rO3iTv34LiUwDh1jtXQ4A3TTCpDWPlu50U7yTwxbRipiNygfmSyh0YbU7+TduD
         nmuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702636368; x=1703241168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gb/T/oASgtKNv+0xZI+c0KBr6jni4i5H3ET7iArrf4k=;
        b=mg/hXxZ1nDLT5jMKr40B37WUruaQglTP5ld8ZaqjbDgpQOGnXZp74Jcq/byjJLCl6g
         5nLeGmUmzM0TEcBh8ibuslJmmlkKtCg3VPTedZAuJ1eeGqhTuZKJ7BTEZ04kq9fEAFv4
         UpPsTwYaGf0OkL6HCU9sypYYLC5XCQGIXrKnEnvK5gciFgT80EmoYLF9Jk8eFrY9h7O+
         bu4HM2F8h3Yb8AJeVwhFKZxhIe5uPzg4ZnXjP2a36TBxvKd/9xJlZc5KECjsgSONm1kG
         dNaYEbBiOlxIpvKb6kOXZXco/tDDTw/NYzm64V+D0r4cYjdQfflUKmA5nJ2yFDmQMbA2
         F8bA==
X-Gm-Message-State: AOJu0Yyn7IijtX4+i4k2+ZXCJpF8LJ1j6G3pkGt4A+QmiuuY/4Uo9tpK
	U/SXsF2rWZz82mlGoOW2Qvxm+TVRwRRLwg1RKmdrRKd0
X-Google-Smtp-Source: AGHT+IG8Ct6WJzJ0E7CAgaD7djI8pdHG3EsYbU7797KHqPA45afy5tK8XwtADVKdXbn0l3c/QKKmZu1MynqEl9lhXpw=
X-Received: by 2002:a05:620a:31a2:b0:77f:38a:e824 with SMTP id
 bi34-20020a05620a31a200b0077f038ae824mr19019763qkb.7.1702636367672; Fri, 15
 Dec 2023 02:32:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231213123422.344600-3-amir73il@gmail.com> <c6c49fd7-2197-48b9-8203-ee5f4634b683@gmail.com>
 <CAOQ4uxj_ikEdF-d3s_S7OGUDk1duUXzYqvB0BkyzFNgrCXYf=Q@mail.gmail.com> <ffc20839-03a6-4f20-82ae-8707b4b9752b@gmail.com>
In-Reply-To: <ffc20839-03a6-4f20-82ae-8707b4b9752b@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Dec 2023 12:32:36 +0200
Message-ID: <CAOQ4uxjT=YGwN1gVDAqRaw0M=q9Gsv7hW2zo9CE9KErqosVx0g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] overlayfs.rst: fix ReST formatting
To: Akira Yokosawa <akiyks@gmail.com>
Cc: bagasdotme@gmail.com, brauner@kernel.org, linux-doc@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023 at 11:31=E2=80=AFAM Akira Yokosawa <akiyks@gmail.com> =
wrote:
>
> Hi Amir,
>
> On 2023/12/15 17:00, Amir Goldstein wrote:
> > On Fri, Dec 15, 2023 at 4:07=E2=80=AFAM Akira Yokosawa <akiyks@gmail.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> On Wed, 13 Dec 2023 14:34:22 +0200, Amir Goldstein wrote:
> >>> Fix some indentation issues and fix missing newlines in quoted text
> >>> by converting quoted text to code blocks.
> >>>
> >>> Unindent a) b) enumerated list to workaround github displaying it
> >>> as numbered list.
> >>
> >> I don't think we need to work around github's weird behavior around
> >> enumerated lists.  What matters for us is what Sphinx (+ our own
> >> extensions) ends up generating.
> >>
> >> The corresponding html page rendered by Sphinx is at:
> >> https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html#perm=
ission-model
> >>
> >> It does not look perfect, but at least it preserves enumeration by
> >> number and alphabet.
> >>
> >
> > ok.
> >
> >> I'd suggest reporting github about the minor breakage of their
> >> rst renderer.
> >>
> >> Further comments below:
> >>
> >>>
> >>> Reported-by: Christian Brauner <brauner@kernel.org>
> >>> Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> >>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >>> ---
> >>>  Documentation/filesystems/overlayfs.rst | 63 +++++++++++++----------=
--
> >>>  1 file changed, 32 insertions(+), 31 deletions(-)
> >>>
> >>> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/=
filesystems/overlayfs.rst
> >>> index 926396fdc5eb..a36f3a2a2d4b 100644
> >>> --- a/Documentation/filesystems/overlayfs.rst
> >>> +++ b/Documentation/filesystems/overlayfs.rst
> >>> @@ -118,7 +118,7 @@ Where both upper and lower objects are directorie=
s, a merged directory
> >>>  is formed.
> >>>
> >>>  At mount time, the two directories given as mount options "lowerdir"=
 and
> >>> -"upperdir" are combined into a merged directory:
> >>> +"upperdir" are combined into a merged directory::
> >>>
> >>>    mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,\
> >>>    workdir=3D/work /merged
> >>> @@ -174,10 +174,10 @@ programs.
> >>>  seek offsets are assigned sequentially when the directories are read=
.
> >>>  Thus if
> >>>
> >>> -  - read part of a directory
> >>> -  - remember an offset, and close the directory
> >>> -  - re-open the directory some time later
> >>> -  - seek to the remembered offset
> >>> +- read part of a directory
> >>> +- remember an offset, and close the directory
> >>> +- re-open the directory some time later
> >>> +- seek to the remembered offset
> >>
> >> To my eyes, unindent spoils the readability of this file as pure
> >> plain text.  Please don't do this.
> >>
> >
> > Ok. I see what you mean.
> > I restored a single space indent.
> > I don't see why double space is called for and it is inconsistent
> > with indentation in the rest of the doc.
> >
> >>>
> >>>  there may be little correlation between the old and new locations in
> >>>  the list of filenames, particularly if anything has changed in the
> >>> @@ -285,21 +285,21 @@ Permission model
> >>>
> >>>  Permission checking in the overlay filesystem follows these principl=
es:
> >>>
> >>> - 1) permission check SHOULD return the same result before and after =
copy up
> >>> +1) permission check SHOULD return the same result before and after c=
opy up
> >>>
> >>> - 2) task creating the overlay mount MUST NOT gain additional privile=
ges
> >>> +2) task creating the overlay mount MUST NOT gain additional privileg=
es
> >>>
> >>> - 3) non-mounting task MAY gain additional privileges through the ove=
rlay,
> >>> - compared to direct access on underlying lower or upper filesystems
> >>> +3) non-mounting task MAY gain additional privileges through the over=
lay,
> >>> +   compared to direct access on underlying lower or upper filesystem=
s
> >>
> >> All you need to fix is this adjustment of indent.
> >> Don't do other unindents please
> >>
> >
> > OK. I also fixed the same indents in "Non-standard behavior".
> >
> >>>
> >>> -This is achieved by performing two permission checks on each access
> >>> +This is achieved by performing two permission checks on each access:
> >>>
> >>> - a) check if current task is allowed access based on local DAC (owne=
r,
> >>> -    group, mode and posix acl), as well as MAC checks
> >>> +a) check if current task is allowed access based on local DAC (owner=
,
> >>> +group, mode and posix acl), as well as MAC checks
> >>>
> >>> - b) check if mounting task would be allowed real operation on lower =
or
> >>> -    upper layer based on underlying filesystem permissions, again in=
cluding
> >>> -    MAC checks
> >>> +b) check if mounting task would be allowed real operation on lower o=
r
> >>> +upper layer based on underlying filesystem permissions, again includ=
ing
> >>> +MAC checks
> >>
> >> Your workaround harms the readability very badly.
> >> Don't break the construct of enumerated (or numbered) list in rst.
> >>
> >
> > ok.
> >
> >> For the specification of enumerated list, please see:
> >>
> >> https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#enu=
merated-lists
> >>
> >> If there is a rst parser who fails to recognize some of the defined
> >> list structure, fix such a parser please!
> >>
> >>>
> >>>  Check (a) ensures consistency (1) since owner, group, mode and posix=
 acls
> >>>  are copied up.  On the other hand it can result in server enforced
> >>> @@ -311,11 +311,11 @@ to create setups where the consistency rule (1)=
 does not hold; normally,
> >>>  however, the mounting task will have sufficient privileges to perfor=
m all
> >>>  operations.
> >>>
> >>> -Another way to demonstrate this model is drawing parallels between
> >>> +Another way to demonstrate this model is drawing parallels between::
> >>>
> >>>    mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,...=
 /merged
> >>>
> >>> -and
> >>> +and::
> >>>
> >>>    cp -a /lower /upper
> >>>    mount --bind /upper /merged
> >>> @@ -328,7 +328,7 @@ Multiple lower layers
> >>>  ---------------------
> >>>
> >>>  Multiple lower layers can now be given using the colon (":") as a
> >>> -separator character between the directory names.  For example:
> >>> +separator character between the directory names.  For example::
> >>>
> >>>    mount -t overlay overlay -olowerdir=3D/lower1:/lower2:/lower3 /mer=
ged
> >>>
> >>> @@ -340,13 +340,13 @@ rightmost one and going left.  In the above exa=
mple lower1 will be the
> >>>  top, lower2 the middle and lower3 the bottom layer.
> >>>
> >>>  Note: directory names containing colons can be provided as lower lay=
er by
> >>> -escaping the colons with a single backslash.  For example:
> >>> +escaping the colons with a single backslash.  For example::
> >>>
> >>>    mount -t overlay overlay -olowerdir=3D/a\:lower\:\:dir /merged
> >>>
> >>>  Since kernel version v6.8, directory names containing colons can als=
o
> >>>  be configured as lower layer using the "lowerdir+" mount options and=
 the
> >>> -fsconfig syscall from new mount api.  For example:
> >>> +fsconfig syscall from new mount api.  For example::
> >>>
> >>>    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/a:lower::dir",=
 0);
> >>>
> >>> @@ -390,11 +390,11 @@ Data-only lower layers
> >>>  With "metacopy" feature enabled, an overlayfs regular file may be a =
composition
> >>>  of information from up to three different layers:
> >>>
> >>> - 1) metadata from a file in the upper layer
> >>> +1) metadata from a file in the upper layer
> >>>
> >>> - 2) st_ino and st_dev object identifier from a file in a lower layer
> >>> +2) st_ino and st_dev object identifier from a file in a lower layer
> >>>
> >>> - 3) data from a file in another lower layer (further below)
> >>> +3) data from a file in another lower layer (further below)
> >>
> >> Ditto.
> >>
> >>>
> >>>  The "lower data" file can be on any lower layer, except from the top=
 most
> >>>  lower layer.
> >>> @@ -405,7 +405,7 @@ A normal lower layer is not allowed to be below a=
 data-only layer, so single
> >>>  colon separators are not allowed to the right of double colon ("::")=
 separators.
> >>>
> >>>
> >>> -For example:
> >>> +For example::
> >>>
> >>>    mount -t overlay overlay -olowerdir=3D/l1:/l2:/l3::/do1::/do2 /mer=
ged
> >>>
> >>> @@ -419,7 +419,7 @@ to the absolute path of the "lower data" file in =
the "data-only" lower layer.
> >>>
> >>>  Since kernel version v6.8, "data-only" lower layers can also be adde=
d using
> >>>  the "datadir+" mount options and the fsconfig syscall from new mount=
 api.
> >>> -For example:
> >>> +For example::
> >>>
> >>>    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
> >>>    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
> >>> @@ -429,7 +429,7 @@ For example:
> >>>
> >>>
> >>>  fs-verity support
> >>> -----------------------
> >>> +-----------------
> >>>
> >>>  During metadata copy up of a lower file, if the source file has
> >>>  fs-verity enabled and overlay verity support is enabled, then the
> >>> @@ -653,9 +653,10 @@ following rules apply:
> >>>     encode an upper file handle from upper inode
> >>>
> >>>  The encoded overlay file handle includes:
> >>> - - Header including path type information (e.g. lower/upper)
> >>> - - UUID of the underlying filesystem
> >>> - - Underlying filesystem encoding of underlying inode
> >>> +
> >>> +- Header including path type information (e.g. lower/upper)
> >>> +- UUID of the underlying filesystem
> >>> +- Underlying filesystem encoding of underlying inode
> >>
> >> Ditto.
> >>
> >
> > ok, but inconsistent indentation between numbered and bullet list is
> > also not nice:
> > https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html#nfs-e=
xport
>
> I agree.
>
> >
> > so I kept this indent and I also indented the non-indented numbered lis=
ts
> > in this section to conform to the rest of the numbered lists in this do=
c.
> >
> > I've pushed the fixes to overlayfs-next.
>
> OK. I'm looking at commit 4552f4b1be08 ("overlayfs.rst: fix ReST formatti=
ng").
>
> It looks reasonable to me.
> If you'd like, feel free to add
>
> Reviewed-by: Akira Yokosawa <akiyks@gmail.com>
>

Done.

Thanks!
Amir.
