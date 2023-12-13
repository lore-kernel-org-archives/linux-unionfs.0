Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bmg6DyP2"
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799EF106;
	Wed, 13 Dec 2023 03:58:40 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-4b2ee35bff8so2241182e0c.2;
        Wed, 13 Dec 2023 03:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702468719; x=1703073519; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bJYW5yXxVNbgWrbBqu6ykoaRla+y5O3rX61yIqV8BwI=;
        b=bmg6DyP2EtqqGazk0RdK2pHFIGC9kFcA2cG1gfjKgRHYlPjUm90AANnhWEfU8N21RI
         b1ckAHYQzd1Fl00zPEgialdfzgvjHSL2j2OxMrTbJOAev7LuyOnzdfk046/eFrnVcXYb
         KIBDZ+q8T2iDEnBOPhKgVPD+Ny2PQ+dCtaK05/Pk35xk67A+zoQ0PMF6gzPPQxx5qvhG
         sEIsOEJjw89eexxOo++hv4Zrb1yHvp2+L2eCTktpbFLUovlBRz9qYwiHXOUDfxFG+vz5
         lBimPOTR6/BAQrS8Ln0roZZcEFHoO1H1I9gND9TzVfulvv2ysAhLNLj1JzDM7aBvfrGZ
         D7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702468719; x=1703073519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bJYW5yXxVNbgWrbBqu6ykoaRla+y5O3rX61yIqV8BwI=;
        b=KtO+Cx84pM4IVqLbxPG9/vIV2FT9SS0ME1ZaJ69M88yRseM/fCZsgcITx3QEXzgOzo
         ZWQLhgOLbLRs18J9gyCgah4yctgenvDQzu7l2y8O+KZ7zFjW1/9qvqovsIqFdh+19PU0
         AX7cKqli6e4fMUcKszVDjCucqhqop74WTzcsP6KGnCtH8pOVTq5CogkXsPfFDgrGNBPl
         PDcJLk41a10D2qZRJgunJSSj/GNlQ+fJ3mYt+uprjK3SPM+aEQT/UNuNCcs3I0tvWYzC
         bUYIlEj/W6IXLLrB5Z+wpQJp3vXRVOvUW0EqyPFGg4VDfICQovVkoKoD0JBmNuqoiw+3
         MuQQ==
X-Gm-Message-State: AOJu0YyFeaXDYoVX8GH2DfcAdAw/yiRecPJZtkQiThp/wolsq4wPuf2Z
	WUX41FyMWYfNKEjYKyFqCUhE1sLgMFoYg+RSOmM=
X-Google-Smtp-Source: AGHT+IEBIT5aN1vDwhu4+FOLNqpegMSUCpaIGhTvXdQLBUs/Ch5UOLd9143bLdmBnA5oXf72T5wgY//Na576s2+LHjY=
X-Received: by 2002:a1f:f28f:0:b0:4b2:c554:dfc8 with SMTP id
 q137-20020a1ff28f000000b004b2c554dfc8mr6401285vkh.23.1702468719430; Wed, 13
 Dec 2023 03:58:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231212073324.245541-1-amir73il@gmail.com> <20231212073324.245541-3-amir73il@gmail.com>
 <ZXk-NPhtH1g57HWt@archie.me>
In-Reply-To: <ZXk-NPhtH1g57HWt@archie.me>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 13 Dec 2023 13:58:28 +0200
Message-ID: <CAOQ4uxj-Jw=F8kZVHGAa74DD6wkQWkyS1nui-Zj7yGy50Qg3cw@mail.gmail.com>
Subject: Re: [PATCH 2/2] overlayfs.rst: fix ReST formatting
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 7:16=E2=80=AFAM Bagas Sanjaya <bagasdotme@gmail.com=
> wrote:
>
> On Tue, Dec 12, 2023 at 09:33:24AM +0200, Amir Goldstein wrote:
> > Fix some indentation issues and missing newlines in quoted text.
> >
> > Unindent a) b) enumerated list to workaround github displaying it
> > as numbered list.
> >
> > Reported-by: Christian Brauner <brauner@kernel.org>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  Documentation/filesystems/overlayfs.rst | 69 +++++++++++++------------
> >  1 file changed, 35 insertions(+), 34 deletions(-)
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/fi=
lesystems/overlayfs.rst
> > index 926396fdc5eb..37467ad5cff4 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
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
> Looks OK.
>
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
> Shouldn't the numbered list be `1.` and `a.`?
>

As I wrote in the commit message:
"Unindent a) b) enumerated list to workaround github displaying it
 as numbered list."

For some reason github displays a. as 1.:

https://github.com/torvalds/linux/blob/master/Documentation/filesystems/ove=
rlayfs.rst#permission-model

> > @@ -421,15 +421,15 @@ Since kernel version v6.8, "data-only" lower laye=
rs can also be added using
> >  the "datadir+" mount options and the fsconfig syscall from new mount a=
pi.
> >  For example:
> >
> > -  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
> > -  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
> > -  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l3", 0);
> > -  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do1", 0);
> > -  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do2", 0);
> > + |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
> > + |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
> > + |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l3", 0);
> > + |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do1", 0);
> > + |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do2", 0);
>
> What about using code block syntax (e.g. `For example::`)?
>

Nice! I will convert all code blocks to use this format.

Thanks,
Amir.
