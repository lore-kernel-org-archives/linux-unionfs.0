Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89F21E4A9
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705927858; cv=none; b=eT9TYesXbL6RHWPYcLNmbiMogM4TH0I9aPrpBFpWRqTXcZjxRQs8YT1VOWqMTYC1+70EOvrM8Y2lOPXy4HHm6R52trRvWaLlKnoU6lQDN3hJ4hmkV6GUBMwhApaCPFpqdutuQpNgcUo0itIcuLfWeVoJA2O6xCg2BETMWXQhtBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705927858; c=relaxed/simple;
	bh=w3bhntqN6FjWLRNh36YyEgNPx6pEhnRz2lFs0LlyPXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ak+a1oe1WYHXdpDn33YFSH7Oxi8om/w9+b6uxdzm+B3haJvTP4oJqj56LcFu+/SmrTX9312GjMSoBH63ByTzsjkE68T2O0TgqoucvNWHPbOCY1fyVxbNKUxIsrQMSix1uHqDtLbm9mca8XprZZJy86hu9iK+JVzXkRIY6Vd529U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=TC5bmbsp; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="TC5bmbsp"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a2c179aa5c4so323277866b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 04:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1705927854; x=1706532654; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DfYx/OXKKEGChK3jTNgqUeTqgCMVU66o3Tp7eiiq1Z8=;
        b=TC5bmbspwy1SSM2AV6OJoF+qgNeVOBkm4cfwselpz9wECKe3/NCmbaFWIhV7Li0FIn
         EFdnm5Hg9OkvCMy27rB1qVQPFzoiQVkot5eyRyR6S9t8o3GYouOS91K2Lr7hcAsxuXIt
         Jn91gAMmGJBDCtCHVGwRCWGNURr5I1NnCcUgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705927854; x=1706532654;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DfYx/OXKKEGChK3jTNgqUeTqgCMVU66o3Tp7eiiq1Z8=;
        b=ggsIPEsRRIuuM+5R4kh5JuTJQpdShdpRaCFUvi92amFBOENSD3wiQdkaRFf7hefvDM
         bLwwpl5SrBeDqkiC4EzU7+IoUpnSjvcdBZ6lC0iYE8BA6dOSz/Sa0+HRPaNXCGTbesFj
         yh/DnAQQdC9EtUhLjIKpTcdSSzRKyjxmsJb9eKr2a+HNGWDCATkSybTHdEJEf7CnhTbb
         E2oeKTNw6KbH+fKyoXoccYafeG0sm9KwCWl+OppIKZMMCX79l6FezU3jhMzInNCS9EXw
         +dB58Dmb7zDXWrC95NgUmqqZEulv0YOgPAPOtCOKvbbkM8vG/UDzeS/rzN3HQoIuMUSu
         ZOkw==
X-Gm-Message-State: AOJu0YyEp4mgSYXWpIp36IWAtIlzOO/Z+vZrhPHTtj4ysxpXeyHLbRWJ
	RZHw10yOP5i7d9y86c79pAkDmFGd2ArtZMTua6kwcyxdouBAPBgn6bKktyydZ69rGurSG6aXQPJ
	zMlJh+V1ixmcfsJFKnPH55+b7jG5FGgQS9nYRx4vHXdbrpKWZ
X-Google-Smtp-Source: AGHT+IG4VZS3R5Ycffj4yzbcDWkpE73uW3o48FQq4R6AZAdfGV1S3VM5hDscQq1bg5dQXx7H8tJojifXWnYiLY66Ngs=
X-Received: by 2002:a17:906:7d5:b0:a2b:1df5:47c3 with SMTP id
 m21-20020a17090607d500b00a2b1df547c3mr1981955ejc.87.1705927853581; Mon, 22
 Jan 2024 04:50:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121150532.313567-1-amir73il@gmail.com>
In-Reply-To: <20240121150532.313567-1-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 22 Jan 2024 13:50:41 +0100
Message-ID: <CAJfpeguGdxktdFrp4ChW3wpVv-A=3HBSNy5HRdG=41H8h-4_DA@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 21 Jan 2024 at 16:05, Amir Goldstein <amir73il@gmail.com> wrote:
>
> An opaque directory cannot have xwhiteouts, so instead of marking an
> xwhiteouts directory with a new xattr, overload overlay.opaque xattr
> for marking both opaque dir ('y') and xwhiteouts dir ('x').
>
> This is more efficient as the overlay.opaque xattr is checked during
> lookup of directory anyway.
>
> This also prevents unnecessary checking the xattr when reading a
> directory without xwhiteouts, i.e. most of the time.
>
> Note that the xwhiteouts marker is not checked on the upper layer and
> on the last layer in lowerstack, where xwhiteouts are not expected.
>
> Fixes: bc8df7a3dc03 ("ovl: Add an alternative type of whiteout")
> Cc: <stable@vger.kernel.org> # v6.7
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> Alex has reported a problem with your suggested approach of requiring
> xwhiteouts xattr on layers root dir [1].
>
> Following counter proposal, amortizes the cost of checking opaque xattr
> on directories during lookup to also check for xwhiteouts.

Concept looks good overall.

overlayfs.rst needs updating with the new format.   BTW the nesting
format should also be documented, but that's a separate patch.


> @@ -292,7 +292,11 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                 if (d->last)
>                         goto out;
>
> -               if (ovl_is_opaquedir(OVL_FS(d->sb), &path)) {
> +               /* overlay.opaque=x means xwhiteouts directory */
> +               val = ovl_get_opaquedir_val(ofs, &path);
> +               if (last_element && !is_upper && val == 'x') {
> +                       d->xwhiteouts = true;

Maybe I'm missing something, but can't we set the flag on the layer?

Thanks,
Miklos
