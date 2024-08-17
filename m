Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B9AF4EE;
	Sat, 17 Aug 2024 08:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723881709; cv=none; b=lyRi1I2EbUC4UNd1XXLrXvuz3TUyGuL3Nu6fm7vBVnmpCozJlv5h46jJLQsBBXzhFIGi3ilPKu1OqJMtPrRQCOnneZh9VE/RPH2J96lv+QyFGGfVxz0C76xIBA2bC7eTEyqpmr3IyI9TCiR9wL4pPaxBJys7n8zpxb8dRjCiceg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723881709; c=relaxed/simple;
	bh=+S23YgQ01yRHSVeVn4Ayk1S3jLmMbK8lcHMOLJ8qqHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BoAT4+YW9uXdd08cQdoFIvXXjLjlzBEKex+Lb/FKnJjqtEE87Vu47geO/cj2b3VwZE7oL8D/9LpbZnppj2V6uID7+O5F/FBR7+DoBnI+yubPkVtazwFobAoPrntUUudPANutEmvchEz9G4byO2OcfayjmNSyLbtmKJ5OzBmEh60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ior3OHlf; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ior3OHlf"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6bf6ea1d34aso15144826d6.1;
        Sat, 17 Aug 2024 01:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723881706; x=1724486506; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3gHgeZYDXTg7ys6BJKkxLif6iqYxYVBQQZWx4XuSGnY=;
        b=Ior3OHlf6BrcSnuRNIlPmYOFpq8lgAnU6A0wCi15XzzsGsUv0dVZgFHPshQhsBw+Sa
         Ywui7mXy6i8568iH7v7U9b6xMd6oO70NMR1BEcZKOnonvm5UoCdY+xT2R06UpyfIMu7N
         VbjU6TMsTieRE0h246+2JWcSdBozODJ/y/4wyxgylRZ0LZQdQAYGYctTAeorYedPd18i
         zRe5dZjdwqAxM0BEP6seM29W1WBKzgyomm2+lpvRpOsCL6wTaiDbubnK2woDzAJDzQOj
         Onmkd5ucuXCJnCFTQWgGZ2rPdNjSnvwF8laR0jgN9dr45B2VLK2Hdu7mfLZfNqWaNtok
         +52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723881706; x=1724486506;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3gHgeZYDXTg7ys6BJKkxLif6iqYxYVBQQZWx4XuSGnY=;
        b=tDFo4j345t4sL6Isg2a2HIRiT8Dt8WCol7qcfdaV8PWN4kbhIW4mcN1L/UOK4/4bTf
         ghT0lrwqd1L9V53NNrxePifSOjaHK9eKTsoFJxMZYGOtFgIufgym9zAJKudqWpifpCzf
         ft/YgSD3NE1kTTd8IivDUKxqgohPlEO5D5bkSvhJvTaaYTzCtZt7ZLgDHWy9Y/GPZrIE
         fQ3tqcIF0sO+/PmYbEFEnn/iB9yubGVM0TyMNkB+NqhBkSdrzjTKd060kmHgtKDZC0O7
         P6BE8TfFyo7h/z+UHBlbjGo6EnlSZ7wCZYMpyffE3v1pXfch6CiiOgFuBSHucZScA1iq
         N4TA==
X-Forwarded-Encrypted: i=1; AJvYcCXAVxabYBKBSu37ywkTKMTVXckxjMc0ygweDrZTM3gl7wVQQ7KQcOCH1vct/BjNg5PbjMP18FiJvSqVyUgCLN7+U0HA3CBMGFlU0r3na1O7rIgm6hbZ1V0Zhlr4GJNACOpyFk8NErxdS+sc+YhViui5KPG0ZrsNGzXjHdq2U6NHV1ww9XxmTQ==
X-Gm-Message-State: AOJu0Yxfr9D9Pht/pHU/In5aSDkKPqJGTWRzK9X6GbfCnsEwQlmHTRwm
	NIKzoyUli/V/efk/X0z5cAnSAXJE/L4sagD79VERgZByyp2g2GfcTqAeZEvltadt2wqc1BCLmjx
	N6f5JUCGNjWLXZwgbzwCupM9ZQyDCy4zLVJ8=
X-Google-Smtp-Source: AGHT+IHdfEZYkzWWtH3eVHA9NBOv/L0PcpYVZxC+qzGefMCSozKg9a4uCqUR6HzUbRjVmCiaLkAX7aFCrx3ExwJgu6k=
X-Received: by 2002:a05:6214:3c86:b0:6bb:3f92:13d with SMTP id
 6a1803df08f44-6bf7cde998cmr60889986d6.24.1723881706255; Sat, 17 Aug 2024
 01:01:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240815203011.292977-1-yuriybelikov1@gmail.com>
In-Reply-To: <20240815203011.292977-1-yuriybelikov1@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 17 Aug 2024 10:01:34 +0200
Message-ID: <CAOQ4uxiRGcPNsad==MtLFGrrwg_Sv-6g0tNwSVtvoSH+2VR5Lw@mail.gmail.com>
Subject: Re: [PATCH] Update redirect_dir and metacopy sections in overlayfs documentation
To: Yuriy Belikov <yuriybelikov1@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, linux-unionfs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2024 at 10:30=E2=80=AFPM Yuriy Belikov <yuriybelikov1@gmail=
.com> wrote:
>
> This patch:
> - Provides info about trusted.overlay.metacopy extended attribute.
> - Extends the description of trusted.overlay.redirect
>   with information about possible values of this xattr
>
> Signed-off-by: Yuriy Belikov <yuriybelikov1@gmail.com>

Hi Yuriy,

This version has some inaccuracies and some irrelevant
information IMO. I will try to point them out.
Please be aware that this is an overview/design document
and it is not the intention to commit to the implementation details
of overlayfs.

> ---
>  Documentation/filesystems/overlayfs.rst | 32 +++++++++++++++++++------
>  1 file changed, 25 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 165514401441..f4b68b8cd67d 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -207,11 +207,23 @@ handle it in two different ways:
>     applications are usually prepared to handle this error (mv(1) for exa=
mple
>     recursively copies the directory tree).  This is the default behavior=
.
>
> -2. If the "redirect_dir" feature is enabled, then the directory will be
> -   copied up (but not the contents).  Then the "trusted.overlay.redirect=
"
> -   extended attribute is set to the path of the original location from t=
he
> -   root of the overlay.  Finally the directory is moved to the new
> -   location.
> +2. If the "redirect_dir" feature is enabled, then the contents of the
> +   directory will not be copied up after any name-modifying operations
> +   (e.g. rename(2), or mv(1)).

I cannot put my finger on it, I just don't like this rephrasing and it serv=
es no
good purpose IMO. mv(1) is not an operation, it is a tool, so the phrasing
is just inaccurate.

> Instead of performing a copy-up operation,
> +   an empty entry will be created in the upper layer with the same name
> +   as the affected entry in the overlayfs directory.

Again I do not like this phrasing. It suggests that there is a copy up
operation that copies entire directory content and that is not true.
chown of directory will copy up directory without content and that
has nothing to do with redirect_dir.

> The 'trusted.overlay.redirect'
> +   xattr will then be set to mark the upper-layer directory, indicating =
that
> +   its contents weren't copied up due to the 'redirect_dir' feature.
> +   This extended attribute holds the previous name of a directory as a v=
alue.
> +   For directories that were simply renamed the attribute is just the ol=
d name
> +   of the directory without preceding path.

"simply renamed" is not a clear technical description.
Not changing a parent is what you want to say, but TBH, I just don't
think that we want to commit to this implementation detail and I am
really not sure why putting it in the document is helpful.

> For directories whose locations
> +   in the overlayfs directory were changed, the corresponding xattrs are=
 set
> +   to the paths to the original locations from the root of the overlay.
> +   The value of the xattr in the second case starts with a UNIX path del=
imiter
> +   (e.g. "/$PREVIOUS_PATH"). Finally the directory is moved
> +   to the new location. The output of du "$UPPER_LAYTER_DIR/$RENAMED_DIR=
"

I dislike the use of these invented variable names that were not
defined earlier in the doc, please don't use that notation.

> +   should be zero.

Not something that we want or can commit to.
Some filesystems count xattr blocks in du (depending on size of
all the xattr) so it is not possible to commit to this statement and
I do not think that it adds much to the document.

> Renamed directory subentries will be copied-up only
> +   after operations that directly affect their contents.

Again, not related to redirect_dir.
This is a description of how copy up generally works in overlayfs.
If you think that this information is missing from the document,
please try to add it to the Directories section.

>
>  There are several ways to tune the "redirect_dir" feature.
>
> @@ -367,8 +379,14 @@ Metadata only copy up
>
>  When the "metacopy" feature is enabled, overlayfs will only copy
>  up metadata (as opposed to whole file), when a metadata specific operati=
on
> -like chown/chmod is performed. Full file will be copied up later when
> -file is opened for WRITE operation.
> +like chown/chmod is performed. When file metadata are modified the
> +corresponding empty file (with the same name as the modified one)
> +appears in the upper layer, however such a file contains
> +no allocated data (a sparse file);

I am sorry, I do not like this phrasing, but also cannot offer something be=
tter
because I am not sure what missing information you are trying to add.

The only thing I would change in the doc is replace
"Full file will be copied up later..."
with
"File data will be copied up later..."

> doing du "$UPPER_LAYER/$FILENAME"
> +should yield zero.

No invented env variables please. we cannot commit to zero du.

> Such an upper-layer file is marked with
> +"trusted.overlayfs.metacopy" xattr which indicates that this file contai=
ns
> +no data and copy-up should be performed before the corresponding file
> +in the overlayfs directory is opened for write.
>
>  In other words, this is delayed data copy up operation and data is copie=
d
>  up when there is a need to actually modify data.

Maybe just add here at the end:

An upper file in this state is marked with "trusted.overlayfs.metacopy" xat=
tr
which indicates that the upper file contains no data.
After the lower file's data is copied up, the "trusted.overlayfs.metacopy" =
xattr
is removed from the upper file.

Thanks,
Amir.
