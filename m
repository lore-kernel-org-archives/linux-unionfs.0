Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793270951;
	b=anjO3CNjnzoNAjLNVzes5s9cgyYFnM6KUgQKXvvhCY+pMZFMQ7uh60vb1FBuOIrEOHLv
	 +9pesIDtq3Z9yUDmGHJUiZaDFQxpgqtdbb5ls48ApPemaDfO7/nS55kBRtFOKWpQAOMtv
	 6XpxpMcGuX+h1XOyff3tUsDJABxp+4XeENKjIopXLaiZhrHVft2HDcc0YqaNIY6ZHjIyC
	 Fv1SQ+EqOFXyvp7RI0Ayks7IMlFVZnSiSyuMtgF43805ILEocB2tBXd7bdftVK0HK9udQ
	 1VLElZPKyBzggOs+7SX2c2a2G5t1DZZB52wPOA7wi0zKs19x2RbY30Sypuai24BA/hA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793270951;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zbmLqSufNSTz7oFSlgljM7qVDxU566qZ/gshg+M3kMg=;
	b=cL0LzQVebGXnpJJh5fNAmGYCLk1sGa1aq92bWctnH9Ufv0v+qEoTzwCuyKB6Hj+HY2QG
	 ZCRLSSgGZ4DGGW7OR17w0Ozp8TPMbv4G7IqHkwlkuJZuDkASHTawQ8YQBep76ytUfucSG
	 jSYt/spyzc9FJmRN8nN4DRtRizPIXQIb/HLx9JxJ+7s8kRp/pXZLwMMUSr6CJ0bz9gqi4
	 4Wiso9dqj3csYsatggAfH+r6PFnL/wLqg8QIn3rUmRWfrfu8hq8NyN5jxzl0g+XLGOBjo
	 utVomq80As9fem38aVWohfzzBY7vPXI3vDagKtKBd+db5gehEuIp13Cfc+7vRFsu67A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BKH3pDyD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2499B606A31A
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 10:49:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2499B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BKH3pDyD
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso2956892a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 03:49:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793270949; cv=none;
        d=google.com; s=arc-20260327;
        b=iyqwlILG3g9K1l9AaWVKLm85ZVoupZfumaal6CfrtLnB70+ANhTEDx/hgAQqMx+TGi
         zgPfPaajTQ8Su67stHOvBbjuDIStGrk9MqeRFvW+uBd3VX6D+1HZ5YXBQVRDUOEHsIXM
         Ld972jl8Hm5Sfs76xZJmGvajWufXsp0a0twgmCKjhdMNwOsd9JdHu5BODHKvNNCCFdEW
         SuTd2fMMOntSGAbjOuq6oMsfBtroJ5kyc+I+cQ3EZvGLDYzwyzfOYCWJSynOUCnwgD7w
         tSEC2UZw699GtpuoW1xmsHzgzQtWegbf4qwX4tk2N2tOyZ8ozsS7C0D9kVJgYOdcz2pl
         OqZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zbmLqSufNSTz7oFSlgljM7qVDxU566qZ/gshg+M3kMg=;
        fh=rU/hAbH3Mf1TXUVq5/l8LFaHAzy9o2Q2lcAwCdmziv0=;
        b=YaYZtatXlMsFEm1VGManSUWKixF0rrAaJL2FqWEAN8EvpbRRh201Ovphrus0aINFU2
         2EUlCpXsz30//hf01SoBeUdCjzeDb3meskNppDqJNCbimP31jQUCrOBuNNiv4UTpgoAv
         X/SLaH1TF9DDLtI7gEQ1bYGodujY2elfxXIHhTikXezkW4C51/IOwiGVX4H4BGw5C81Y
         GzAPACYPSaQqDaFxCXxvyOSd4Q198d49IzA0jBpen9bKu7CiekV6X9kkV7dRoDB4R7bq
         2mUzCe4qW9zUoGOzCUL/xBq9sjHOmarCGY3Dl3XAfyFzMxzXDpKB54tQnnTyJqmuymIg
         H23A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793270949; x=1793875749; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zbmLqSufNSTz7oFSlgljM7qVDxU566qZ/gshg+M3kMg=;
        b=BKH3pDyD8Peoi6VBs/TTujk77dzyHxS3Dh1lNPIzpHjV27LsMgouencJlZ+5iLCn82
         jFejVtTnjK8TchiFPnwi+6upbTkIgLtdeAN8ULmxNXbo1eY/VuHrfWvxTEgOxwmKDGii
         TydXYPE8ZH9Z/D5BooPg5oFWTlTlSsvKKCRDsMfV6/619zhBDXUDuJFymXX6FXkBP9yJ
         Gd78HpNM21fCDq1+m8c4NY1IK77qDtwfh72JcRuZlgwOt0VRFV3gQnic++QjxYp2Pf6x
         KAKEZ/2yG0O+rf3mODFP+WZkIeUQIefmrXwGNlACGd0fkSmU2TdvddgLjRIPJjxeOQDf
         nwRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793270949; x=1793875749;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zbmLqSufNSTz7oFSlgljM7qVDxU566qZ/gshg+M3kMg=;
        b=qCyXuPoNq4SUjllAPAI5pjthnzZvaNLzjRp2xg7XvgTOvY9e57Yo2A2NCbs8iEe0Op
         hMVfIWWIGTYrPOFV2om5r7g1qjtM1lSPbdlD9vgYv0+dGzQbO0GkZtHD8EgCsH2e7nCc
         YXw/y+G8QZB2SB53l7SpezxQCbBBOH48d6U6aEUaGAdQmZQYBiVf7tTmhNqbpwScFieO
         sIAlDZcNq7AaUvFFDvkVY1cD6KeKP2FrnHoTW4kDQQxpn7XI5N84tBdK+D6Wtuj94jq2
         H0+KZqLHSxc9EpnkHXB9e8ldDfXYS9879Yxg5v0exo11l3cM4CpXprsUh+H9QemODcLK
         kLFg==
X-Forwarded-Encrypted: i=1; AKwUvBwsgs2+gBni6fAaEt3B6YinTmIvGGHK0HWUA3ll1J3HM5ll9LB8yVcD9X6Ex+xnsDlOJRRykivD21HT+khX@vger.kernel.org
X-Gm-Message-State: AFq9FYJz5k/aeanGTTXS6r2z82BdMkq6qLR5oymrlGf/zdCGqArNc4u5
	TCYgG2Rsz99zrPsBQGWBioEjHfpMZ5VMkNJruA7A1JQ1p+aE+567dGpCtfe1bWF4PCkgTEiucS7
	uPtRJO7RfKngrDTZpLzxxQRbpujQVc9E=
X-Gm-Gg: AYBFou2iQ7b2MOAjoJgW5pRsVknwBTButN0lkum0aXKvaXq6QA+VONZr6ydjiiN+dU/
	fPVxlwKIEfia1eIgC7JQIDa9HkZptvXOwNpL1hGum4kYg80yCUV4F5bF1uSBd2JjivbykSUOrTP
	GJMOAPkQmKx/gObvGi06siGtKHkf5lMUg8/WK+36eZLzv4G7c22UCNEdId/VA0omnCKagYHfcvX
	hAn4BpURIMg0xYEpGGKckmtJDY2XsH/IZCMK9TAY2fwJEjfLQsDxJ7hZmh9P/xDwHgmUq+4PjhX
	v7CdygrGIQQhthU/qoGZSu6R0Ts151cC1sv4cTjzb8nxRmA0qFErObIzqHRht+RFNaxAMl7MZLJ
	eLor4NV2sJQDXfPHoOFampSY264fa9T7k8zTEX2S1Me83sL4n68S/QzcwPQ940w+RnCIMhuFhoM
	9f87LvDLgg6mretOw=
X-Received: by 2002:a17:906:eec8:b0:c46:723d:600 with SMTP id
 a640c23a62f3a-c49bdfcdd65mr457878766b.41.1793270949125; Thu, 29 Oct 2026
 03:49:09 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029103913.2785828-1-amir73il@gmail.com>
In-Reply-To: <20261029103913.2785828-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Oct 2026 11:48:56 +0100
X-Gm-Features: AclHuK8r166-yi4e5XCpY2GFgL3aAI1tQ9q3Pix1qn3NFJ5gY5SUbe4Q2pHlDUw
Message-ID: <CAOQ4uxjDJPo5ectRdOh9T3oRCL=JP+n8KvvS4O4CssSMH8uCWw@mail.gmail.com>
Subject: Re: [PATCH 00/16] Overlayfs fixes from Chris Mason (batch 1)
To: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
	overlayfs <linux-unionfs@vger.kernel.org>, Chris Mason <mason@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 11:39=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> Hi folks,
>
> The following batch of patches is part of a collection of overlayfs bugs
> reported by Chris Mason.
>
> These bugs were found by Chris' AI code scanner (kres), but underwent
> extensive manual auditing and filtering by both Chris and Josef.

Sorry guys, I meant to CC you on this cover letter but missed.

Also apologies to the fuse list for spamming them with these overlayfs
patches by mistake.

Amir.

>
> I thank them both for handing me a reasonably sized pile of patches,
> most of them important, correct and ready to merge.
>
> The patches selected in this batch were either simple enough to merge
> without questions or important enough for me to invest the extra time.
>
> Patches that I changed include a note [amir: ...] with my changes above
> my signature.
>
> Notable changes from Chris' version:
> - Include "fortify ovl_copy_xattr()" and "assertions in dir cache"
>   patches already posted publicly for similar reported issues
> - Use LOOKUP_EXCL in "do not copy up a dentry that was removed"
> - Add vfs helper try_take_dentry_name_snapshot() instead of open
>   coding it in overlayfs code
> - Fix for empty security.capability from Josef adjusted and rebased
>   onto "fortify ovl_copy_xattr()" refactoring
>
> This pile applies cleanly and was tested on top of 7.3 and on top of
> master of the moment.
>
> Backports down to 6.1.y are either trivial or already prepared in
> my local tree. I will make those available to the stable maintainers
> after upstream merge.
>
> PR will follow soon.
>
> Thanks,
> Amir.
>
> Amir Goldstein (4):
>   ovl: fortify ovl_copy_xattr() against underlying layer modifications
>   ovl: add assertions in dir cache code
>   vfs: add try_take_dentry_name_snapshot()
>   ovl: skip copy up of empty security.capability
>
> Chris Mason (12):
>   ovl: do not copy up an xattr value that was never read
>   ovl: set OVL_WHITEOUTS before publishing the upper dir
>   ovl: check that the parents of volatile/dirty are dirs
>   ovl: take a snapshot of the name for copy up
>   ovl: do not take a name snapshot in RCU walk
>   ovl: use the pinned upper dir in ovl_fix_origin()
>   ovl: hold a reference on the parent in readdir
>   ovl: do not copy up a dentry that was removed
>   ovl: fix a torn path in ovl_get_redirect()
>   ovl: read the nlink xattr of every indexed non-dir
>   ovl: always encode the origin fh when index is enabled
>   ovl: set the revalidate flags after d_instantiate()
>
>  fs/dcache.c              |  29 +++++++++--
>  fs/overlayfs/copy_up.c   | 110 ++++++++++++++++++++++++---------------
>  fs/overlayfs/dir.c       |  22 +++++++-
>  fs/overlayfs/inode.c     |  14 +++--
>  fs/overlayfs/namei.c     |   8 +--
>  fs/overlayfs/overlayfs.h |   8 ++-
>  fs/overlayfs/readdir.c   |  61 ++++++++++++++++++----
>  fs/overlayfs/super.c     |  21 ++++++--
>  include/linux/dcache.h   |   1 +
>  9 files changed, 203 insertions(+), 71 deletions(-)
>
> --
> 2.55.0
>
