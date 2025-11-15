Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC78F1EDA2C
	for <linux-unionfs@vger.kernel.org>; Sat, 15 Nov 2025 09:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763198879; cv=none; b=tTdQKMCwE3dxButFJDYYFl22iP8Bx94t1Oor7ofw8CnY+MyBasaKD7Ll7v1/VTJOhWjdBWELoQkQ+2xovuwAk/3NPd7HQKUDMYdobru8wLVPiSVaQMhrSPHWN7otGsDmOE5+NzwT0YFTLdYK1To30PHVp4rFCsXHgYDX94Miidc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763198879; c=relaxed/simple;
	bh=ZTF59b2xNDDFgLhDYSsQMUX/BWRIBQ1xlcqM94AmZEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPuLyBCwf3R/J72Ug0v4/V+z16kCDiZHbP4+ZZct8ez9XixIQJJBh9V5rW6491sATvDmUo+AYm2xgux0bK9yxiq8vBoJYyKK+58M3PGAmCGYPJ+wt4nU6uUVKu14XYMxduLI61tqKDX4aL9ceNiunztc/i4Ho/PvDWEYNY8oT2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KfU2BOrx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sZ6h3NaY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KfU2BOrx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sZ6h3NaY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763198875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y2P37KFvvmOE9DmPPuKba7HiL5DpBrnCOzu+gEYRDQI=;
	b=KfU2BOrxrcPBeHxi6BYN8vPf0YaMxYWo9RBRPpHJxlYm0THiKQlzajcHbkG/FVXwRIT+5F
	xp5qhTF3xqsqolmTBmLvDYCbMJmZUFEXfry25CMxioeGun2108K2Gv2wNgvKymLpBq8QEz
	PGD6nNDURLcF9q9k8HzlHHNUDRiAkPg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-2DMV-8IwOFenih7xyriIow-1; Sat, 15 Nov 2025 04:27:49 -0500
X-MC-Unique: 2DMV-8IwOFenih7xyriIow-1
X-Mimecast-MFC-AGG-ID: 2DMV-8IwOFenih7xyriIow_1763198868
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-297dde580c8so86950845ad.1
        for <linux-unionfs@vger.kernel.org>; Sat, 15 Nov 2025 01:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763198868; x=1763803668; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y2P37KFvvmOE9DmPPuKba7HiL5DpBrnCOzu+gEYRDQI=;
        b=sZ6h3NaYztvBzB/F4kQ0XUamipgj3+4HDFed0sNEk4Tsy97Oh7TO0iPiA8q9Ij9Y8t
         DhxQSKlQkv7uArZY7lIqEDzhZKAtirhUKtanlcZbVVoiRq5ZshcYl+VlujNTdwqPajhe
         STYIFeeqYg9hnOYuGoyxvrRlfnlK/Av0OltYGR0rBpnll8847AMnX/RGEoBWkSPk3u79
         q3PBqseVmfS+KoGNi+5JmVpe/JMHI3cj5IWw1DNc0wGLpAAPOwRceRCw2ppYUvNOz9qc
         N2zOR5UPiP7RKi0aa/plwrENgDMsyU21FNRiMzJC2CyYpuHCQ/vI8DH/UAtEcIgoblXh
         /URg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763198868; x=1763803668;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2P37KFvvmOE9DmPPuKba7HiL5DpBrnCOzu+gEYRDQI=;
        b=CwF3yG5lGQVFw6SbLgYHsHEKjQcpcoTTUEPi7k8sBYUJRMpZBZPp6oHilO30F4fNwE
         QIOrTeM+APhuJffWGCajOj32qQF7UPUleCBb+B/RP35PZHr4vvmolRV4FfWkMhPsCxhz
         NDE411ekw42eCE7GpWtOnyP5K82Fp+lbBIhe/C3AwxG+SlfCwfPTTqdAsk+UA7XDbz/n
         ffOj9zgIUtZY5u126MgynEcHMny8K2L4tFpO1LVNJjcmi/MfmY9f9Km5kI7Hb234shJd
         S5oRFb7FWlhM2xBbKIL7AjPX5rrb8jgY+4GxQIaMayJgFufRvDas0iLw9yz2csICSoqH
         STug==
X-Forwarded-Encrypted: i=1; AJvYcCVmeUIY5QthkeiVN5H72v0FDb/oOM3G2D05EskR1Bs3qEYNa8ncRVVjIUxVDOaE1V0uzZ6+ADSkr/DSBCeA@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7HB9pUo5/KCFaBrFs7yXNJ1sv0YvBveuPwwCHd3X2mU0yMqMQ
	nSh6nTpmf0Ts+cyjUkTjLwwZd8c1MyNMgeN/fcaz+Ljz5ZrH9V44kMSgyzh6eD/TfacLk8xATLH
	e+wSfEJX/quWiSopKzykAU5TkqOww7cph9D7zlCYR1rporiDkAj9LB+WALimOgXo0b6Q=
X-Gm-Gg: ASbGncsg4CBISnE6wahX4sBHTaad7d5pnr9MGujOgnve/cfbFaillagI+TUDJG6V08q
	Ba3hJszTQODoZOH9U7S4klOyxmhQhk4kXrbSsylEVH6Vn/I0V255L6YL7FLmWM8cFEjLwlSQc3J
	fCGIvZ0GW76gwsCCmOsrEAuVg+M3tyK/LGsJDFD7KI0Ip2u90RESFqv9adiAUu3SeRhnyZo10fF
	ii+6IqcB4KvXrX46I8JPOmxs1KvmhKwbHjYbwFq3GnjvSTJ+olbwGKMoUeWrSIPMNVJSkwDDrOC
	E4xPOLxNxFLSnRTgilEhWOKdhzymZrbCZNVQoK/uEE4r3j35WWCUXgFeraENSjFw1N0/Zf7xAvH
	H/2mdJGkUuLB/q0kIN/ulbJvcrOtXMScgEk6A4O0XI2cDLA5OWQ==
X-Received: by 2002:a17:902:d4c4:b0:26a:8171:dafa with SMTP id d9443c01a7336-2986a6d225dmr72565385ad.21.1763195248450;
        Sat, 15 Nov 2025 00:27:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMbZzwsVejum2cvopjzBYNN7ahllxuix+DaBpHGx5GQCjCruGNPprcS65m6kyAR6Bvr2FAcw==
X-Received: by 2002:a17:902:d4c4:b0:26a:8171:dafa with SMTP id d9443c01a7336-2986a6d225dmr72565255ad.21.1763195248016;
        Sat, 15 Nov 2025 00:27:28 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c245e04sm77947555ad.38.2025.11.15.00.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 00:27:27 -0800 (PST)
Date: Sat, 15 Nov 2025 16:27:22 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] overlay: add tests for casefolded layers
Message-ID: <20251115082722.vyqrtmnrabnnl2qd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251114194852.1344740-1-amir73il@gmail.com>
 <20251115071102.pelohvzihg4aafse@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxjWWTm7wYK9737V89ToYgF6gSZ4TD1=tr58nNehk5rcoA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjWWTm7wYK9737V89ToYgF6gSZ4TD1=tr58nNehk5rcoA@mail.gmail.com>

On Sat, Nov 15, 2025 at 09:11:33AM +0100, Amir Goldstein wrote:
> On Sat, Nov 15, 2025 at 8:11 AM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Fri, Nov 14, 2025 at 08:48:52PM +0100, Amir Goldstein wrote:
> > > Overalyfs did not allow mounting layers with casefold capable fs
> > > until kernel v6.17 and did not allow casefold enabled layers
> > > until kernel v6.18.
> > >
> > > Since kernel v6.18, overalyfs allows this kind of setups,
> > > as long as the layers have consistent encoding and all the directories
> > > in the subtree have consistent casefolding.
> > >
> > > Create test cases for the following scenarios:
> > > - Mounting overlayfs with casefold disabled
> > > - Mounting overlayfs with casefold enabled
> > > - Lookup subdir in overlayfs with mismatch casefold to parent dir
> > > - Change casefold of underlying subdir while overalyfs is mounted
> > > - Mounting overlayfs with strict enconding, but casefold disabled
> > > - Mounting overlayfs with strict enconding casefold enabled
> > > - Mounting overlayfs with layers with inconsistent UTF8 version
> > >
> > > Co-developed-by: André Almeida <andrealmeid@igalia.com>
> > > Signed-off-by: André Almeida <andrealmeid@igalia.com>
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Hi Zorro,
> > >
> > > I fixed the bug you found with tmpfs.
> > >
> > > Please note that I did not assign a sequential test number because
> > > I wanted to let you assign a non conflicting number when you merge it.
> >
> > Thanks Amir :) This version looks good to me, just one question below...
> >
> > >
> > > Thanks,
> > > Amir.
> > >
> > > Chages since v1:
> > > - Fix test run with tmpfs (needed _scratch_mount_casefold_strict)
> > > - unmount MNT1/MNT2 in cleanup
> > > - Use _mount _unmount helpers
> > >
> > >  tests/generic/999     | 242 ++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/999.out |  13 +++
> > >  2 files changed, 255 insertions(+)
> > >  create mode 100755 tests/generic/999
> > >  create mode 100644 tests/generic/999.out
> > >
> > > diff --git a/tests/generic/999 b/tests/generic/999
> > > new file mode 100755
> > > index 00000000..c315b8ba
> > > --- /dev/null
> > > +++ b/tests/generic/999
> > > @@ -0,0 +1,242 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (C) 2025 CTERA Networks. All Rights Reserved.
> > > +#
> > > +# FS QA Test 999
> > > +#
> > > +# Test overlayfs error cases with casefold enabled layers
> > > +#
> > > +# Overalyfs did not allow mounting layers with casefold capable fs
> > > +# until kernel v6.17 and with casefold enabled until kernel v6.18.
> > > +# Since kernel v6.17, overalyfs allows the mount, as long as casefolding
> > > +# is disabled on all directories.
> > > +# Since kernel v6.18, overalyfs allows the mount, as long as casefolding
> > > +# is consistent on all directories and encoding is consistent on all layers.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick mount casefold
> > > +
> > > +# Override the default cleanup function.
> > > +_cleanup()
> > > +{
> > > +     cd /
> > > +     _unmount $merge 2>/dev/null
> > > +     _unmount $MNT1 2>/dev/null
> > > +     _unmount $MNT2 2>/dev/null
> >
> > ... I saw you mount $MNT1 and $MNT2 at first, then mount $merge:
> >
> >   mount_casefold_version "utf8-12.1.0" $MNT1
> >   mount_casefold_version "utf8-11.0.0" $MNT2
> >   ...
> >   mount_overlay $lowerdir (which mount on $merge)
> >
> > So I think unmount $merge after umount $MNT1 and $MNT2 might (looks)
> > make more sense, although I saw you've tried to do unmount_overlay
> > before _cleanup :)
> >
> 
> Conceptually, overlayfs mount is a stack, so the correct order is
> to unmount the top of the stack ($merge) first and then to unmounted
> the base fs of the stack ($MNT1,$MNT2).
> 
> In practice, the order does not matter because overlayfs mount does
> not prevent unmount of the mounts that were used as upper/lower,
> but there is certainly no reason to require unmounting them first.

Oh, my brain went blank, Sure, you're right :)

> 
> Thanks,
> Amir.
> 

