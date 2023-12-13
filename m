Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IH//JhBd"
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA3DA0;
	Wed, 13 Dec 2023 03:26:24 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-3ba084395d9so2294423b6e.0;
        Wed, 13 Dec 2023 03:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702466783; x=1703071583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6ML0ly7w4x3IcoxK6kKjw4POy/vTf1Q0LT5CXiDqvM=;
        b=IH//JhBdgRqdfY9I3lnEL/mpDeljFyAb3Ttu21XNs7Jp6CnLeUxaF7Kp5rFHBO/nfd
         nVOz5P9TmZ7DQ5Vqe/cLX1juswq12yp0AZBPnsVExEftRgZyu6/0trn7meacsAHE92aL
         zLnbwFzIJCf6th8eSmp9YsUVsZBzWl27eWmjdZ+CIYLnS7r4V8EY6R/HBH8khn2wlxcz
         VgNAeQNuh5QebJG5vIsIQMO353pXexk8W1f84iRR7QoAkEtHjQ4T0eUIG6aCEFy8uWt4
         G8af6M6JsIZetcyqmmIxzyhg2rqDaiqhTNVzDK6K1nLY+zWbMhYX3gId1XLensb3mdf2
         OVeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702466783; x=1703071583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6ML0ly7w4x3IcoxK6kKjw4POy/vTf1Q0LT5CXiDqvM=;
        b=d9OyipFIh9PfBTIJnSseVfB+azaZBpU3fUtaRQEQ1yL2GvJ4AevI/EoI/7j8lw8guM
         vB/uxCR4C6jcykcKKGGAgUXGHBxFpDkpMW2bWEoCJLLGsW7pWPGm9f2BHWByYOa7EySU
         yI7JqH1Ia/dguaOAF3+CwNJqRxZ0o5VF9kh3lPAofrflXcXFaUBHQf2U8ktl8ZkPs5d/
         yLK8Wd9Dhj/gqp4kF+7QOI0hozAPZTSk/cuxJ2UOV+lVH5JgQ7YVzBuNkxMKRFbMZZjO
         ws30RZUSXma/QAcp3syhanUjSOZxgA8rnlSKtraUzvB+Y9rS9Pff+afZCjyT54cjt7+k
         NQ8w==
X-Gm-Message-State: AOJu0Ywo6blPXjlneHSAN0D1cu2ZQRWRkw6XNRdvTfCCKZCjd2AZv0SO
	UO+IJnB4mTGdrA67ZsK/2I0SP8UYUEpdE3ev2KdI3WUO
X-Google-Smtp-Source: AGHT+IEaX11OTz0PCl0brrfMbyk5S8saff5GltHyoHeUTrANuR99mSVO+FzUpxPlSl3VjznPDUKMUyp1kSqueHc6IVw=
X-Received: by 2002:a05:6808:2082:b0:3b9:caf1:96bb with SMTP id
 s2-20020a056808208200b003b9caf196bbmr10151690oiw.52.1702466782600; Wed, 13
 Dec 2023 03:26:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231212073324.245541-1-amir73il@gmail.com> <20231212073324.245541-2-amir73il@gmail.com>
 <ZXk6eNa8n0n1Uerb@archie.me>
In-Reply-To: <ZXk6eNa8n0n1Uerb@archie.me>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 13 Dec 2023 13:26:11 +0200
Message-ID: <CAOQ4uxhxxvTUmyxMiPBOoDu8wFvGBx7PH4HU4bH66yt9RrNOAw@mail.gmail.com>
Subject: Re: [PATCH 1/2] overlayfs.rst: use consistent terminology
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Linux unionfs <linux-unionfs@vger.kernel.org>, 
	Linux Documentation <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 7:00=E2=80=AFAM Bagas Sanjaya <bagasdotme@gmail.com=
> wrote:
>
> On Tue, Dec 12, 2023 at 09:33:23AM +0200, Amir Goldstein wrote:
> > -1) "redirect_dir"
> > +redirect_dir
> > +````````````
> >
> >  Enabled with the mount option or module option: "redirect_dir=3Don" or=
 with
> >  the kernel config option CONFIG_OVERLAY_FS_REDIRECT_DIR=3Dy.
> > @@ -568,7 +569,8 @@ the kernel config option CONFIG_OVERLAY_FS_REDIRECT=
_DIR=3Dy.
> >  If this feature is disabled, then rename(2) on a lower or merged direc=
tory
> >  will fail with EXDEV ("Invalid cross-device link").
> >
> > -2) "inode index"
> > +index
> > +`````
> >
> >  Enabled with the mount option or module option "index=3Don" or with th=
e
> >  kernel config option CONFIG_OVERLAY_FS_INDEX=3Dy.
> > @@ -577,7 +579,8 @@ If this feature is disabled and a file with multipl=
e hard links is copied
> >  up, then this will "break" the link.  Changes will not be propagated t=
o
> >  other names referring to the same inode.
> >
> > -3) "xino"
> > +xino
> > +````
>
> Why is there section heading conversion above (not mentioned in the patch
> description)?

Because it makes the document look nicer.
I will add a note about it in the commit message.

Thanks,
Amir.
