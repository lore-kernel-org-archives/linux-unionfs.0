Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6309113B2A4
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Jun 2025 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749144767; cv=none; b=UW09n0h972ss4vYrcEJX67FkFKgHd9DbK31Qxu7KuUQbibA14Gh2an4AfjWFX2qsaJ2EQLqj+d6QcmoQ9rQA/hBBMPDAoe6P6YRUSciZxVFhLMxiDYR6WeouKVAbRuwBZAKRt1QQoACJQ6/ifKzvoeK4XyWJMvkCCMfYSPKmF/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749144767; c=relaxed/simple;
	bh=ZrgYdKtEEmMov1IXq8Qvd/Cd4gvh0W8IsZWoEUS6lOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+0+Xao4f58+wjdInEeahIhSWhA2OjtmuSW6/fvYxyFlyCfP8bhng07iwG/UGAG9mRvXmogISCQeTu8ryQf5lP5quLeZ2IQmPihlneBe/8YPqAIzM1vB9aOB4g//wzvbjHopMzSm19PZsw+xpl2ms1iBv/vEacf8oswVLLY0gaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V6Tk/5d7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V6Tk/5d7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749144763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SbqvG8bC3Lf/tJ1TxTXVtxh04QlkVtdqv1xGSMI3+W8=;
	b=V6Tk/5d7ybfN1AvAqKeYrTAtao8ZQ7Rj3QM85pAkPyUULRAQtqMxiORZQbQv99mG7WISU5
	AXWe4jyc6QR0yOGOZ/FVYyDP8ynlOO82Ejy/SZvGEOWDh7RpWvF8m4Bhce6vB9rXXhfePw
	WPoBwwThUMn2Hc0pCweT93aAE8Oepf0=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-kXjsyWFZNaWpzU0utzjSjA-1; Thu, 05 Jun 2025 13:32:40 -0400
X-MC-Unique: kXjsyWFZNaWpzU0utzjSjA-1
X-Mimecast-MFC-AGG-ID: kXjsyWFZNaWpzU0utzjSjA_1749144759
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b2ede156ec4so1416058a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 10:32:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749144759; x=1749749559;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SbqvG8bC3Lf/tJ1TxTXVtxh04QlkVtdqv1xGSMI3+W8=;
        b=jeHSUp3d/kfK+h2G6E9kPpf5KB7vxfU6j+D9oIEyPQdrcOcj4RVcyY+pMoSwih54RU
         m7pga0KKMfta8Kgtw3ybhL0/yvhDwIunKjxLlaOXnbbzTsHFxTP5Jj2lXdoz53phWYhM
         3gKIpw14W7NJufc9m1eFXoy5BPAgRv5JsnRSSbn0PtRLDI5kg+7Pn9qM0v2k8uVLufJV
         T4B1vYq3Zi1GUPiDpUbYIgAwR66R0bcrhY5Tiezp7Ayp0blHQLywn+xB/CAtTyxLEYq2
         iB/OmvgvSGVVBOqie5Qrhs0AXeLZHOlAFLUrguFg1uPYP4z/lsNQ0SdtPT4mJdhCz7Cv
         17yQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW96QUtelzJnokFHW+VewBzPoq8qzFBsxt7l8mD1MawVYo/tGb8dbk8gHa5wSNDlkfjQOGUNyu6J5/lPhj@vger.kernel.org
X-Gm-Message-State: AOJu0YxBpXOe3svIZCoI+1T/ZNn/bodSqkyHox1ihdoZao0laeLW/Jsr
	0qDgpFGVozVxMkCoQXGfEy+mffrj/JApQybY+0MI7cR1Mm6bV9Cr+1uaO2/GeDOgqhhe4Bni0iq
	G0/z+y26sPFBAXdXwlhWi6sOqkNLTVOiQfUSC4l8ieBv+isUqS7iEU3tcwCWvthbcVgA=
X-Gm-Gg: ASbGncvSx3MUWe52Vt4oN6hR6rQOkb3bniVJWMvibjGsAfNin7D9Op9PGv6aj7EH3ZJ
	V2F1ScE9xOLz5UnQX4HhK+AQ3zVbiPr1/m37+ssI8BX4ktFnh+asWpO5YN85ZjFeXesbp9hkpGL
	h+IybqL8U7niM44+mrba+TmvIidpui0f9VZrRq+FISBg0rmfkv/IfxLjk7UM8065DjLFH1nB4mn
	RZw2cXprP0OKY/Ekky//q9YD0iZivcw8yzej5/TSe6q6IqSjSX8QS5R+AcVHErRr1CbLPpcZhVd
	IDfK4zs75WgsA+5bnxfhw3KwpeMES9gOf5wRPlX0WsA8qzBQIVMd
X-Received: by 2002:a17:902:e88a:b0:235:ec11:f0ee with SMTP id d9443c01a7336-23601cf96d6mr3497135ad.14.1749144758971;
        Thu, 05 Jun 2025 10:32:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyFzj8ca92j9Fblwdd1kTqgenHF8POiDPCuqyb6y5JQYt5dJJLLdZNGS70UdvPO9qCqUCaNA==
X-Received: by 2002:a17:902:e88a:b0:235:ec11:f0ee with SMTP id d9443c01a7336-23601cf96d6mr3496765ad.14.1749144758613;
        Thu, 05 Jun 2025 10:32:38 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506cf53a9sm122147345ad.196.2025.06.05.10.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 10:32:38 -0700 (PDT)
Date: Fri, 6 Jun 2025 01:32:33 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 4/6] generic/623: do not run with overlayfs
Message-ID: <20250605173233.ndqsjo77ds3e35p5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-5-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250603100745.2022891-5-amir73il@gmail.com>

On Tue, Jun 03, 2025 at 12:07:43PM +0200, Amir Goldstein wrote:
> This test performs shutdown via xfs_io -c shutdown.
> 
> Overlayfs tests can use _scratch_shutdown, but they cannot use
> "-c shutdown" xfs_io command without jumping through hoops, so by
> default we do not support it.
> 
> Add this condition to _require_xfs_io_command and add the require
> statement to test generic/623 so it wont run with overlayfs.
> 
> Reported-by: André Almeida <andrealmeid@igalia.com>
> Tested-by: André Almeida <andrealmeid@igalia.com>
> Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/rc         | 8 ++++++++
>  tests/generic/623 | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index d8ee8328..bffd576a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3033,6 +3033,14 @@ _require_xfs_io_command()
>  		touch $testfile
>  		testio=`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
>  		;;
> +	"shutdown")
> +		if [ $FSTYP = "overlay" ]; then
> +			# Overlayfs tests can use _scratch_shutdown, but they
> +			# cannot use "-c shutdown" xfs_io command without jumping
> +			# through hoops, so by default we do not support it.
> +			_notrun "xfs_io $command not supported on $FSTYP"
> +		fi
> +		;;

Hmm... I'm not sure this's a good way.
For example, overlay/087 does xfs_io shutdown too, generally it should calls
_require_xfs_io_command "shutdown" although it doesn't. If someone overlay
test case hope to test as o/087 does, and it calls _require_xfs_io_command "shutdown",
then it'll be _notrun.

If g/623 is not suitable for overlay, how about skip it for overlay clearly, by
`_exclude_fs overlay` ?

Thanks,
Zorro

>  	*)
>  		testio=`$XFS_IO_PROG -c "help $command" 2>&1`
>  	esac
> diff --git a/tests/generic/623 b/tests/generic/623
> index b97e2adb..4e36daaf 100755
> --- a/tests/generic/623
> +++ b/tests/generic/623
> @@ -16,6 +16,7 @@ _begin_fstest auto quick shutdown mmap
>  
>  _require_scratch_nocheck
>  _require_scratch_shutdown
> +_require_xfs_io_command "shutdown"
>  
>  _scratch_mkfs &>> $seqres.full
>  _scratch_mount
> -- 
> 2.34.1
> 

