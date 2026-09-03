Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F42264B0CB6
	for <linux-unionfs@vger.kernel.org>; Thu,  3 Sep 2026 13:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443488; cv=pass; b=VlpLWyIHvcnwivSdd9BjD8qdQA3GrtmFEzDvQ7/Td2njFe4lsAxFdzd5Nr27arYMfMkjT4fH9ZEOJC7G9+7IwfkdCuoBlBU3EhvqvSYtLXUbMPmdtqR9Rwq1MOTzjR9VaD1vv0m+zhF4ALcZERB8RrK5po8A+bz3bEXVAl3a/R4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443488; c=relaxed/simple;
	bh=CnepmmzELbEjghYI6j0ZociAv62uiRsm0df/ajYLGG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QVCXEojFOU+so8P5xpJVvf6BOdmu1bpF/oqBMACKnLLRarTj76yrHcmi/VoU+1OEBH5eud+zjTkDahR4+HByW83amE/GwQ0U0gFtHDLDNO8KgfwFEa2HGVdmY//YW82jPUWao0L/oFKG2TY7DHreJqf9besOuUVmdiWBjMW+BgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ihCbHIw4; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihCbHIw4"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a600a1caf8so690918a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Sep 2026 06:51:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788443481; cv=none;
        d=google.com; s=arc-20260327;
        b=EpOVRJIbb7eCb2yPQsa1Djp9M/L3Aspf3qDRD0PhJ76294vg99isyszGfSK2iCI5ch
         Lhk+yqyhuQyMFCxNYOutB5U6BZoUhvdgQtFmcUBfDxfQco8r4oQyFAXaSpvvv7GY7Hjh
         dA2RWMEll7h5Z2DvRgn2fea/BirJjcxFJQkZtg2yifQOlMKk27HYCk1wgYkh2w0bJzsC
         HlwqOrBN6rpfxASHVx66qG/Rf46zS2/pL/myZEc19HwPMPuU8s+ajG3JOInp5LJPX7lw
         CaN+m2cieOp11coO0/fDoSbpdkj+k6eMxryIOVLmpxNDbNi+VBTDhNT0aLURZb5EUFzR
         J1iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MoZRNEtYIWDS0IurH9QV+UfQGtgGdZsOItW/ktopJYY=;
        fh=A7bRK1c4tUQJPuzhceM3ylSrtRtNTEguxo6/psUFkHY=;
        b=KKJtfp7r97gevDC/O+4Gw+3NjPXKlk/YUJ8yPZnYxZEV4fzWpVJ6ynUItWi6e9npFg
         VWc4ujvW/TX44lpSDOXOfzAjSACIR/Gwh2xiVtILqqZDwxkSquMzuSBEktM3fcAm7EB0
         pAuxjfYQjIEWD51XTtzBLTv60b1ymt0+QNUlS5DRY6+vTTwn7yoRsPUBWB09UaFbdo8y
         loqkAKkLMxeLhcIoHbKY16CttCG0Q/ZJi0Qv7Y1xmoyoPIFyxQ8SbWeN6UQIqqmsbiT6
         C7EVWeeipx6k3k9OBnWkXXWT/wWXxWfk0aROc9RbzJdvWxz+ZkJbiE73rxR+d/wp6y5Q
         tBTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788443481; x=1789048281; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MoZRNEtYIWDS0IurH9QV+UfQGtgGdZsOItW/ktopJYY=;
        b=ihCbHIw41Cpllq2Pdrh1AybFP3rOn56Vt67U8mhzTSoyolGHCYUbHv4mgyX8LmDPp9
         GC4gmUyplFlmhdyahxu/XXLRq9TvT2kSymhB2d5I/2p/IRx+Cl8Rh7zhYqb96ArMB/lU
         PdG1cKmWln3Q/5xkUbxma5JpP6W+HwsDBHnHFUu1DUnqSwi4iUbF/5I+O6UOVcFuOKf+
         MFLQDWDtmc7GNngbWlRYEWQEoLrHzfhKG6m6RCH8taLlZ5LlMPJn4Dp5n2DauRFZ0K9N
         KGYuaFgYVfvF+/HYsdNOQS7LNfQqm7OfBudQDfyV7vMdB56z6HaKIWFqFGWwVy9tYJjM
         4h0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788443481; x=1789048281;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MoZRNEtYIWDS0IurH9QV+UfQGtgGdZsOItW/ktopJYY=;
        b=p7aC4WHfLxNkiE2I4knRiqHRw/55Zgmt3+6KoNNorNKDdSQCcHYKEee7L8/lbdBmPj
         MV3gC9msJKdw8M/lEIFB4sW18GlA2MDmAeSxkfg6UCJ90tPOjQGaYmokdoHrDkWcEabF
         qCGEyyC6pC+xLkY87Oj+yXEM0bHJS2o+2qC8fk05vjoQT8Q9G+vvUzsXcC0mrbZq3BQR
         M7ZxL7tr66Mwf983IovgvnaPiZEabzk08lqGRX5V07ewBiW+YWYHzjw425W4FpHexPgp
         zk6aB30st05UrBSl4/A9UihlRZb0FbqSbOKdXRq0FbddF2L0HE9vQewMJpSHHtPmM5LL
         /Rkg==
X-Gm-Message-State: AFuF++lx9kyGy0Zjsiu3sD5K7YxmVzS5wekm9CMqvVqp9TCW6WlWANJj
	91Sop58o8N+IJ7siWjmI9Ls2S8MIH/ntdtrpECQf1JsOa7yQGsRAnwT3yqtkzSW5W5eWPOkqqka
	5zzOyL1ezn+yKFguETMeINbJ1QErbgIo=
X-Gm-Gg: AYBFou0hQEjPnCwnUz0isE1zCuArWUAS+Ay9ekAgMCDZgc2R3D2rnYbgqH4PLep6HrK
	qZoLvcJdkcReiShfpc7Dyt+x/QRyVWPa+iqjtsn1DAmxSouMVmWgGDwhNlXlTP+jQMCAdnZmmXA
	JhUUZlerXaZ065rTptSrAri6dMhx8SFJezI0/IPnoAaFFzUfzR8a9zQHYz2AToVv7K3yO4GHLP1
	v46APsLYUEdiMB396kjSMpKYCpQ9yuWax9W1AaqRrNggIZoQmkvoF3lMPSa9B5pl1HkUkcW1Hfa
	O/8En9fFjVfRzbaEwwnHx48XmYfLNWaw8zuQkmq+lOXWGV+FON8wObsG
X-Received: by 2002:a05:6402:4615:b0:6a5:f814:2278 with SMTP id
 4fb4d7f45d1cf-6a7e551f77bmr22171a12.2.1788443481155; Thu, 03 Sep 2026
 06:51:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903132636.1113789-1-cui.tao@linux.dev>
In-Reply-To: <20260903132636.1113789-1-cui.tao@linux.dev>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 3 Sep 2026 15:51:09 +0200
X-Gm-Features: AcwNN1XLPOGjY6GkGn_VD8RO3WKWNti90NMjrqMlxwQvVF-i2CTvjSe5-uBDR5U
Message-ID: <CAOQ4uxg6_0wnzBmA+-rZeADBTKwLsWFdEM5ZVGa6YvWX6mAGXA@mail.gmail.com>
Subject: Re: [PATCH v2] overlayfs.rst: clarify the scope of file locks taken
 through the overlay
To: Tao Cui <cui.tao@linux.dev>
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	brauner@kernel.org, jlayton@kernel.org, Tao Cui <cuitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 3:26=E2=80=AFPM Tao Cui <cui.tao@linux.dev> wrote:
>
> From: Tao Cui <cuitao@kylinos.cn>
>
> File locks and leases taken on files through the overlay mount are
> only meaningful between tasks that access the files through the same
> overlay mount; they do not conflict with anything that changes the
> underlying filesystems directly.  Add a short note to "Changes to
> underlying filesystems" stating this scope.
>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
> Changes since v1:
> - minimal note within "Changes to underlying filesystems" instead of a
>   separate section, per review (Amir Goldstein)
> ---
>  Documentation/filesystems/overlayfs.rst | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 16c35b491dad..11af5bc73e32 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -671,6 +671,15 @@ filesystem are not allowed.  If the underlying files=
ystem is changed,
>  the behavior of the overlay is undefined, though it will not result in
>  a crash or deadlock.
>
> +Note that file locks and leases taken on files through the overlay
> +mount only provide mutual exclusion between tasks that access the
> +files through the same overlay mount, and a lease taken through the
> +overlay is broken by opens through that overlay.  They do not
> +conflict with locks taken on the same files by anything that changes
> +the underlying filesystems directly, so file locking cannot be relied
> +on for mutual exclusion between overlay users and such direct
> +changes.
> +
>  Offline changes, when the overlay is not mounted, are allowed to the
>  upper tree.  Offline changes to the lower tree are only allowed if the
>  "metacopy", "index", "xino" and "redirect_dir" features
> --
> 2.43.0
>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

I'd like to wait for Miklos to comment before merging this.

Thanks,
Amir.
