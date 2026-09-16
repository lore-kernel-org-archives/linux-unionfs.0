Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13D945DF48
	for <linux-unionfs@vger.kernel.org>; Wed, 16 Sep 2026 07:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544474; cv=pass; b=smzjLqRVP5udGSA4pPbF0bfgs2vTxeXw+fP0XEDajg6S/MK2xzjQ+3GXRzC5QSglw/bhvrkE/dJY2yeQv4gMZhNMh2zVYZNUe67OYiXRDHFRTFLdU274kfgKBgACfMAAGp1UR//U4vR2ZtiaHiZRDBoWOGqmZanwhpiF72YOMW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544474; c=relaxed/simple;
	bh=M8pRcMGQRTIP+kQ8VfnfZ54kvYrrn3fp/02SwxtALTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dez4gY0fhsLBF++4ngPasy9jSBu/ffsxePJizcNjesMfsg5kA2EFOy33IWsoCFgST95Dzlj9+jhcy1f2leT4xnpz4NyVIAGmBe8+NlJo4a2dErOuVgTyI+9gQpt3Ez+8oEUAviF0fiJiE45TRbNZguvqTFbdDgm2RF5bb7FpecE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iIhuOsRz; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iIhuOsRz"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c294ad260fdso263755466b.1
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Sep 2026 00:40:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789544447; cv=none;
        d=google.com; s=arc-20260327;
        b=P26vxdOFtgmOExy0Xi14LaVWbe72E352rYxSCiQyKtE/hg1y6dWnuHZi3LrVCFVg0V
         RcSJiVz38VJzAkstfdnDEp/uYxfoX6MrU+qLbeUfYUqKViaQU6tyRHBsog2NJ7YKwtww
         PK7ROC4emwqI9umMMnJQJ85IQLGpwQORmhYgWffeRb+MWSyyriVVHyJLY9k01p6QoEFG
         OaU1tpzhNZdngzeKp5dny3p7PFAVy/6kO96wgt4lV0JpoIpewP2psOKYYN2jrRwxFcZx
         pgwDHqMD342wXPmzCt3854M2GUhFHh9fPD6KoQRDAXuQTdpqmHpclnsDn7FyVKOgYHH6
         qmHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+M4oZ9nb/hEYtuRbtOM0Toay3Yhov8xHH6hfoGELzcw=;
        fh=Rq4mqgoLftlE+KWduNQprHZEH3jIKXTRNL+fFNXPwlU=;
        b=acbF0jSwOnmEV2xfgDaq1SA/Kom6ci8Yv2RU411QstX8r66xACpYSnHvweWK6p8bJH
         D9HgXo8CouNg4LAOH/JD0TCvqhYMIi2lrQpmCaTs1tDRIxngHu9j43d5nNcCDRMNTi85
         sg9SI4mkWrQor5FMVv12T9foGhHAijTPSDL5x1GfcnxFuucq+dsTkDB3VlNYUCr9E2rc
         hbQ9kK+kS1hL/wyXO4IyMW5Z2CDxsvlGpD+PF0VywJSBZQRKvciJ+6bRRnCFmLrllmKd
         5lQzWd8UvwhpcbdiZq+s46/89CsWueSsUrf15/bOIj1ql/18A/UoiIOWm89aguPR+OfX
         uufw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789544447; x=1790149247; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+M4oZ9nb/hEYtuRbtOM0Toay3Yhov8xHH6hfoGELzcw=;
        b=iIhuOsRzi2qZWsH/pG74vySYpIQEjjah8gatUbi6FlRgVLR6IFy4+hHKmKjFMUnrhB
         /QDmVYBDGO9EU6z//J3m5o1g2aGeSjULMCx2OOGmlqV4Kiz/SPy89Vx89mPUvKuOpJod
         ehS4Ojq2ggohGQ0WbLUzpmRYO9jSiiQTOg/nQnU9H0fFA6H71h0ItuKhi2NmXFhtmU/b
         WkyPUCISyjf+p8XCKUSso3TWjYeC8cDUtqA02LQBD7Vn/PIW4a+CRkhhVRyzqpSlz/t+
         33LA8fUMn6iDPRFIBnlYB6nHggkqthbFAfIWzF2eA+oQV2lqzmNpWIeq7y/QshhdLSav
         kp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789544447; x=1790149247;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+M4oZ9nb/hEYtuRbtOM0Toay3Yhov8xHH6hfoGELzcw=;
        b=thQw80CJQX+JVkFrdwsVYzdYyIV8EsjIAjtJY+xZ6bXCJsgzfBgE7oprFeaAo1Vow7
         /WCThHuKOojcGj/u6cQhQbZ6dUsw7E9yx9y9buFAmoreaYL9tGfqUqE7nbRfQYv+bYmd
         cay5hKHpQfKdv5m35Wumj4I5iYzhGBO4VvL0/C0FIuPfR746EPz8Rf+8OlodoOXYe3o6
         LIIHTxOW26rYP7DEBLvhDMKXteFDfn/hVyXdSWojPEjBesxdTi4tp57TxC76xjv1jj7o
         bkr15PnSBqooaf6gdWrZpPudrPja6m0aQ16mSP0z3xxzK9BNagcm2GAH4HaorawkIa8t
         gqaQ==
X-Forwarded-Encrypted: i=1; AKwUvBxDhfv+ymbqcbqz23qltfYjWRrRkNjOZQstLmJ0c1lKjEwTx28P/WqUSe2aLGxsTmCmwKZ8g6c8co05jqAU@vger.kernel.org
X-Gm-Message-State: AFuF++l3K27bpmRHJxZ2qnKj9ieEdMzE3ND6KhGx8KG8UnDLPiQLbGc/
	9xNHCiNskADyiG7lKRVnlTStZ0dQW9tWNqU1nFB4hcBQa0GLk9CJWN2sUk/xOzIUyic9m+KGGvc
	r5trvDE8re3alrlTkGKFCgJOKFwZAvzM=
X-Gm-Gg: AYBFou3NgztHLjwG00qOWPOZsrvaIcxLRrJSwTi4f+s4likUZGAj8ccanSjce5liLhW
	soAYg/kVfnCCWYENTDIQRivESn/ZMUAgzKQ55QeM6LbNnXpVq6n6ahdJBicFoUelE0EGIYT6eD6
	n2Tn6EdOolyHH+kevDtaIVB1qlw8XktiMZL5DxkKLaGBUx1rwLYZmSnlybGV4jzc3Q/vW1aJ9BY
	eAd66tA5Qm883CN442Mhf44ehtGBGC8C3jDcHNaB06toOlFlleGlOttmp6bjPEE9EGq/NYtP6X3
	R/jD0omHQ/dYQNQOsAKRHIiZ87tpM+VXjwClvwUGyn0d+k3DegZ7TPII
X-Received: by 2002:a17:907:3e29:b0:c25:5e10:1ca9 with SMTP id
 a640c23a62f3a-c29c8909440mr497060866b.5.1789544446596; Wed, 16 Sep 2026
 00:40:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915153608.5197-1-prabhakar.pujeri@dell.com> <20260915153608.5197-4-prabhakar.pujeri@dell.com>
In-Reply-To: <20260915153608.5197-4-prabhakar.pujeri@dell.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 16 Sep 2026 09:40:35 +0200
X-Gm-Features: AcwNN1X4MoyZ92wboGsfOYs8Iuj1ZOnM6KNgoCDVKfP0RDJ8hZDI72D4_NWZ5lg
Message-ID: <CAOQ4uxgYKTVKg_zYAj+pEYFNvDPZcX0VXWJTzwLYKqXACwps3g@mail.gmail.com>
Subject: Re: [PATCH 3/3] overlay/081: require uuid via _require_scratch_overlay_features
To: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 5:36=E2=80=AFPM Prabhakar Pujeri
<prabhakar.pujeri@dell.com> wrote:
>
> The ad-hoc check hid the mount output and treated any mount failure as
> 'overlayfs does not support uuid'.  Route the requirement through the
> generalized helper instead: the probe mount still rejects on a pre-6.6
> kernel with EINVAL, and the options check remains via mount options.
>
> Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
> ---

Thanks for following up on this.
You may add
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

after fixing the nit below

>  tests/overlay/081 | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/tests/overlay/081 b/tests/overlay/081
> index 2270a047..bef54470 100755
> --- a/tests/overlay/081
> +++ b/tests/overlay/081
> @@ -14,6 +14,11 @@ _begin_fstest auto quick
>  . ./common/filter
>  . ./common/attr
>
> +# Unique fsid mount options (uuid=3Dnull/auto/on) were added in kernel
> +# v6.6 and have no module parameter; the probe mount in this helper
> +# _notrun's when the kernel is too old.

This is really too much of a comment.
It should be pretty clear to test writers what's the purpose of _require_
and the v6.6 information is already written in the test description less th=
an
10 lines above.

Thanks,
Amir.

> +_require_scratch_overlay_features uuid
> +
>
>  _scratch_mkfs >>$seqres.full 2>&1
>
> @@ -36,8 +41,7 @@ lower_fsid=3D$(stat -f -c '%i' $lowerdir)
>         echo "lower fs and upper fs fsid differ"
>
>  # Test legacy behavior - ovl fsid inherited from upper fs
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o uuid=3Dnull =
2>/dev/null || \
> -       _notrun "Overlayfs does not support unique fsid feature"
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o uuid=3Dnull
>
>  # Lookup of test_dir marks upper root as "impure", so following (uuid=3D=
auto) mounts
>  # will NOT behave as first time mount of a new overlayfs
> --
> 2.55.0
>
