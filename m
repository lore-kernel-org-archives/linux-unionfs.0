Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D142113C9D5
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Jun 2024 09:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718269307; cv=none; b=m5Xgz8qkvqGGJ9HE7jDTnCfqnpLigcsa83ZzfpbKdGziT3HbvBvMh0AeiWfV97dkRYo4nY08MzdfrH5liAyagpOKzJo+692gDD+eZsLjaMgZ1lELPFeuWmKYJsyiMK6h1hzudoMxqMjM2uoNGfGmi65dhxzWSu2q4oF3iN2d5+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718269307; c=relaxed/simple;
	bh=GnX/56+12k5Nb9KgkOs6/URfuFuU8BeEx2Aq465c3vc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RUGEDCHES3sszLsqD+v5J3ilp9To8dJmmb6llQImZtrjieJCdTXqJF+ZqAwkM1TlGu7DJtLTD2S26Up+fzuqFeZGSdM1RwBKeCZP3KSBEIngW9sS5jzmFGBJ6w8SfptAb8uBoxjBbMOPdlThS/Jj4Ok2malORATzX3YlzRAXZE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=EIcWav9X; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="EIcWav9X"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a6267778b3aso64869666b.3
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jun 2024 02:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1718269303; x=1718874103; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i/Y6yy4sBWvROFty0/Gu88OPsPXIcwkyfMhi3dK/NSY=;
        b=EIcWav9XSnNYj05LEg7MRq0xaxnlwuY0S4vxx/ehyC/NfDvHYii+0z3oaR5dUuJ/ZY
         jZQWBHOkKfo9W2iKRC+CEWgmx1H2gi77wVmhEikaaJFE4qTRE8YiR1fjQfdQijafn26C
         yMA0szpat41tem/9oMYjNq9EEfmz3/e92BkMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718269303; x=1718874103;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i/Y6yy4sBWvROFty0/Gu88OPsPXIcwkyfMhi3dK/NSY=;
        b=sHZgwEvQ1hKjLapBLPpRasYDsbCY0/Yk/e/5jFJYfNjDWiYrzhJBDMWA7i00IiJt9U
         9pnSXGpZvlGkEIfbgQ0gpkrcXeqO6cDOjF0BXAA9jl2Zw1oz0W7bH06fOQP6K3QCDhYx
         h0jSxqWC4xi8ulsYtjrbOzHXeTvB7ZRDxbmF6ZJaHVa+8MEPJxcSovsL7JGSIrGzvrXJ
         rTQRXTD7wnGt2DMejeRILbfRDrFejmSruKWbL6bXXl35H/41SOD8Zt/2RTKGDZrURq+L
         vqG3Z1g6oZVgtI6589ZyXmVDLcCOttBTtiASuGVckUM7IGCnxWExWujbg5+jGR7s+wMi
         L2zg==
X-Gm-Message-State: AOJu0Yybk+JMjokHCsPeYIfFE8KNoaeEiQM/180BhPpTGb6sMGUoVD8G
	d9NThuTPdqqptw1Uuiz3gC/dkzfIKot00dTPyY7yPmQ63cov2yQdCXelv/qwsTaSnoq+HPQtx93
	0JWFcfG0+YMUO1AkuYhNLZcdzVtXQR/Pkez2jkA==
X-Google-Smtp-Source: AGHT+IGKtB7kvIYj9wC9bPL2GdSCin0ObuJfg6KByOTibIALkbNRKqmkqQ4mTPmXM7S75aImqhMcwf8gQxTYfq/GuFA=
X-Received: by 2002:a17:906:6812:b0:a6f:e04:a093 with SMTP id
 a640c23a62f3a-a6f47f7fce2mr257923766b.22.1718269302805; Thu, 13 Jun 2024
 02:01:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADpNCvaBimi+zCYfRJHvCOhMih8OU0rmZkwLuh24MKKroRuT8Q@mail.gmail.com>
In-Reply-To: <CADpNCvaBimi+zCYfRJHvCOhMih8OU0rmZkwLuh24MKKroRuT8Q@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Jun 2024 11:01:30 +0200
Message-ID: <CAJfpegsCsBjHNTEe+6RmeLK7jb_gz_YB=CD-RKUWiscG8u+1cQ@mail.gmail.com>
Subject: Re: crash inside ovl_encode_real_fh() due to NULL dentry pointer
To: Youzhong Yang <youzhong@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000006c445a061ac1bfde"

--0000000000006c445a061ac1bfde
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Jun 2024 at 03:32, Youzhong Yang <youzhong@gmail.com> wrote:
> I analyzed the crash dump, here is what I figured out:
> - The overlay fs is mounted with only 2 lowerdirs, and nfs_export=on
> - When ovl_dentry_to_fid() is called on the root dentry:
>    - ovl_check_encode_origin(dentry) returns 0 as euc_lower (I believe
> it should return 1 in this case)
>    - "enc_lower ? ovl_dentry_lower(dentry) : ovl_dentry_upper(dentry)"
> evaluates to NULL
>    - NULL is passed as the second argument to ovl_encode_real_fh(), so
> it crashes

Thank you for the excellent report.

The attached patch (untested) should fix it.

Thanks,
Miklos

--0000000000006c445a061ac1bfde
Content-Type: text/x-patch; charset="US-ASCII"; name="ovl-fix-encoding-lower-only-root.patch"
Content-Disposition: attachment; 
	filename="ovl-fix-encoding-lower-only-root.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lxd15yyv0>
X-Attachment-Id: f_lxd15yyv0

LS0tCiBmcy9vdmVybGF5ZnMvZXhwb3J0LmMgfCAgICA2ICsrKysrLQogMSBmaWxlIGNoYW5nZWQs
IDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKLS0tIGEvZnMvb3ZlcmxheWZzL2V4cG9y
dC5jCisrKyBiL2ZzL292ZXJsYXlmcy9leHBvcnQuYwpAQCAtMTgxLDYgKzE4MSwxMCBAQCBzdGF0
aWMgaW50IG92bF9jaGVja19lbmNvZGVfb3JpZ2luKHN0cnVjCiAJc3RydWN0IG92bF9mcyAqb2Zz
ID0gT1ZMX0ZTKGRlbnRyeS0+ZF9zYik7CiAJYm9vbCBkZWNvZGFibGUgPSBvZnMtPmNvbmZpZy5u
ZnNfZXhwb3J0OwogCisJLyogTm8gdXBwZXIgbGF5ZXI/ICovCisJaWYgKCFvdmxfdXBwZXJfbW50
KG9mcykpCisJCXJldHVybiAxOworCiAJLyogTG93ZXIgZmlsZSBoYW5kbGUgZm9yIG5vbi11cHBl
ciBub24tZGVjb2RhYmxlICovCiAJaWYgKCFvdmxfZGVudHJ5X3VwcGVyKGRlbnRyeSkgJiYgIWRl
Y29kYWJsZSkKIAkJcmV0dXJuIDE7CkBAIC0yMDksNyArMjEzLDcgQEAgc3RhdGljIGludCBvdmxf
Y2hlY2tfZW5jb2RlX29yaWdpbihzdHJ1YwogCSAqIG92bF9jb25uZWN0X2xheWVyKCkgd2lsbCB0
cnkgdG8gbWFrZSBvcmlnaW4ncyBsYXllciAiY29ubmVjdGVkIiBieQogCSAqIGNvcHlpbmcgdXAg
YSAiY29ubmVjdGFibGUiIGFuY2VzdG9yLgogCSAqLwotCWlmIChkX2lzX2RpcihkZW50cnkpICYm
IG92bF91cHBlcl9tbnQob2ZzKSAmJiBkZWNvZGFibGUpCisJaWYgKGRfaXNfZGlyKGRlbnRyeSkg
JiYgZGVjb2RhYmxlKQogCQlyZXR1cm4gb3ZsX2Nvbm5lY3RfbGF5ZXIoZGVudHJ5KTsKIAogCS8q
IExvd2VyIGZpbGUgaGFuZGxlIGZvciBpbmRleGVkIGFuZCBub24tdXBwZXIgZGlyL25vbi1kaXIg
Ki8K
--0000000000006c445a061ac1bfde--
