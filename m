Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3D05BADB
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 10:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706004187; cv=none; b=FXsIUsIUqBIrjgWWELn+cK9BMBaTYPc9RVYJWqT3/151wzGZjJ2nLKu9NnagtaqrbrdBphJ89iORKXdpx/vz1Fs/1UC43S89QyAtE50/FPxNluB6nWcVO0OtGqM54zmwty7zuHATWFfHAFMVyPI1gCELcUJA9LY5ac7hGD+MhcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706004187; c=relaxed/simple;
	bh=S3ZdLHlJULDWCIrcb8mKSMtcWZeqkzUgxlvrueEWJwo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KAgAWw7jbg38g+lLuQpkCh6TYx63MIUkl0peUAAL7xvPieY/a+J7mwMYpwbMis9t3s3tPxoj2SkMC6FD2nFVR3a81DfMQUybh0tgNHh4/tM598MK9Rra8yL3pWIdjpqOAnc7Az35rJLRRhbhPpFSbqumxHt4W2R0JOmHlDB7WqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zc5hMyXP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zc5hMyXP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706004184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L+lDhKlHap4GXCZJmErGyl3XCHcAWnN8LvVacysm03Y=;
	b=Zc5hMyXPPq401nEPuNn4Hz9VwopQqVGIlBSuFfHXYmFQbzvDfwJWrhwfTAkT4oqXcwrKac
	oukAKOBCLbFt9BaPBdDjQ3BWEScMSoOyJZUx86WjpCAIISB01VIheEGFv8+ylzxyM0MeKx
	OQ2O1LekfPzaWXxNiJWMb1PTvDa6SJg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-3vW0KbQAPraMznPr0ht2TQ-1; Tue, 23 Jan 2024 05:03:02 -0500
X-MC-Unique: 3vW0KbQAPraMznPr0ht2TQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5100a0f0c55so255377e87.1
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 02:03:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706004181; x=1706608981;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L+lDhKlHap4GXCZJmErGyl3XCHcAWnN8LvVacysm03Y=;
        b=bVUXmao4BaeUvpU1yivyH/1LLStcHOS1HgcTzrKXmu2h7FCwLqV9RMf/5oVkZP1/46
         UX1fCqnqDRuOeNmPr83aUpXaCslpx8tI0Ts8T2cZ6jXJqwkqXU5+5u+GBnzT5j9ph6IP
         OQWO6GVPkIM7SzCCQnEWSoitTnvQy68CrQdNeDASQCGPD6ygTbBGkBBrjyR8TcI+kZVV
         7WFS61ZAe+4FD1Vt6DNtssO+KqaGCrFLkMYzMfvxYvYTeNTE6CcNP6UKoUGf9QAXFntV
         /dxX1S6C6xRBAdcyHMRCcWoXnIg5Gj8LKf1RW8Pd0epK00aaS6jsF/flKJJp/D4KRjz9
         RYBw==
X-Gm-Message-State: AOJu0YyJuQFLwlkjNEnYsn78j3jW9POFl5vPwNmRe6dWg+dTM4RGj7q5
	8PZWzw+t6sNUpPlIF5tqNP8Z2s1tf3rfU5LnY71ou47hcyboxCxzZ7o8DK8O8lf94ZnaEOelc8a
	xCdcAYFbe0CcKrF9NA3FtanlE90mRFDSxi/mWvOPYAeckv4Irjkno/xh0SqOGXJU=
X-Received: by 2002:ac2:46d8:0:b0:50e:70b1:9544 with SMTP id p24-20020ac246d8000000b0050e70b19544mr2154353lfo.111.1706004181288;
        Tue, 23 Jan 2024 02:03:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/48S9xNoDcpcqQZZNDbAOF3HlAkoXFCFkYPPBdVFv/VuwtgK0PkdcWt5WsTKyPnAuBFaTqQ==
X-Received: by 2002:ac2:46d8:0:b0:50e:70b1:9544 with SMTP id p24-20020ac246d8000000b0050e70b19544mr2154348lfo.111.1706004180953;
        Tue, 23 Jan 2024 02:03:00 -0800 (PST)
Received: from [172.31.0.10] (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.gmail.com with ESMTPSA id s14-20020a056512214e00b0050ffa29dd74sm732168lfr.18.2024.01.23.02.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 02:03:00 -0800 (PST)
Message-ID: <f0a8ba01f4c98faed4949cbf8b1b7d959d0b3bc2.camel@redhat.com>
Subject: Re: [PATCH v4] ovl: mark xwhiteouts directory with
 overlay.opaque='x'
From: Alexander Larsson <alexl@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Date: Tue, 23 Jan 2024 11:02:59 +0100
In-Reply-To: <CAOQ4uxhQtCXPNzJcmnsH_B6_zM7JrTnUcmjrTxqLstkVcFdz6Q@mail.gmail.com>
References: <20240122195100.452360-1-amir73il@gmail.com>
	 <734d0570edb1a8150c902e6bdd509b597deea186.camel@redhat.com>
	 <CAOQ4uxhQtCXPNzJcmnsH_B6_zM7JrTnUcmjrTxqLstkVcFdz6Q@mail.gmail.com>
Autocrypt: addr=alexl@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-01-23 at 11:53 +0200, Amir Goldstein wrote:
> On Tue, Jan 23, 2024 at 11:05=E2=80=AFAM Alexander Larsson <alexl@redhat.=
com>
> wrote:
> >=20
> > On Mon, 2024-01-22 at 21:51 +0200, Amir Goldstein wrote:
> > > An opaque directory cannot have xwhiteouts, so instead of marking
> > > an
> > > xwhiteouts directory with a new xattr, overload overlay.opaque
> > > xattr
> > > for marking both opaque dir ('y') and xwhiteouts dir ('x').
> > >=20
> > > This is more efficient as the overlay.opaque xattr is checked
> > > during
> > > lookup of directory anyway.
> > >=20
> > > This also prevents unnecessary checking the xattr when reading a
> > > directory without xwhiteouts, i.e. most of the time.
> > >=20
> > > Note that the xwhiteouts marker is not checked on the upper layer
> > > and
> > > on the last layer in lowerstack, where xwhiteouts are not
> > > expected.
> > >=20
> > > Fixes: bc8df7a3dc03 ("ovl: Add an alternative type of whiteout")
> > > Cc: <stable@vger.kernel.org> # v6.7
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >=20
> > > Miklos,
> > >=20
> > > This v4 is a combination of your v2 and my v3 patches to optimize
> > > xwhiteouts readdir for the intersection of a dentry with
> > > xwhiteouts
> > > on any layer and a layer with any xwhiteouts on any directory.
> > >=20
> > > Alex,
> > >=20
> > > Please re-review/test.
> >=20
> > Looks good to me. The only thing I worry about is the atomicity of
> > ovl_layer_set_xwhiteouts(). Doesn't that need a barrier or
> > something?
> >=20
>=20
> I think it does not because:
>=20
> =C2=A0=C2=A0=C2=A0 ovl_layer_set_xwhiteouts() is called before adding the=
 overlay
> dir
> =C2=A0=C2=A0=C2=A0 dentry to dcache, while readdir of that same directory=
 happens
> =C2=A0=C2=A0=C2=A0 after the overlay dir dentry is in dcache, so if some =
cpu
> observes
> =C2=A0=C2=A0=C2=A0 ovl_dentry_is_xwhiteouts(), it will also observe layer=
-
> >has_xwhiteouts
> =C2=A0=C2=A0=C2=A0 for the layers where xwhiteouts marker was found in th=
at merge
> dir.

I see what you mean. A layer getting has_xwhiteouts updated
concurrently via a different dentry may be missed, but that doesn't
matter for the readdir result, because we're guaranteed to see it if it
actually affected the readdir dentry and that is the only thing that
matters for the results.


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's an impetuous vegetarian stage actor from the Mississippi delta.=20
She's a radical tempestuous bounty hunter who don't take no shit from=20
nobody. They fight crime!=20

