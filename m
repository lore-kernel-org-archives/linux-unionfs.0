Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433411EF0AC
	for <linux-unionfs@vger.kernel.org>; Mon, 28 Oct 2024 23:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730157243; cv=none; b=Lz1BUj8VRdt6JVCoOXdFReWvegWRvhAkpo08KjV07AQ25xTUtKEEiGbGNpjG8vh3o7WBfQfDQ08L+m7pNVZK2e6a+uRx5rEsBKBw/hWN+mT0w3PeMyHgeukuw1/AgX1Qkaxl3sSUsJY4+LrMcAeQfCRi52Mla8Hh3mQT+ShjV1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730157243; c=relaxed/simple;
	bh=tu7v26i2JtqQ76K4P5euoorWyDdw9X0DNikmEhAJje8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B6msvRA5OIgPPwiEd/FTlzDp5aDFPGRxHEr1GxFT0lavtUFNA7ic8MCdFenkXEif+wu0FI891TJCAV3zDicckmW+/62fwbYIjHOKLj1+Tp6tnswxX1m3U0sYAv0ys7jFlEtlcE78Pxktyn+cpXfkiZfZaNgqs1+hl+F9elvBXbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=3RAmAuTh; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="3RAmAuTh"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20cdb889222so45531055ad.3
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Oct 2024 16:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730157239; x=1730762039; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MjohkZCWItx1P1zaOWN8RLXGPxIli/Tp9Ueq+8PbQ1c=;
        b=3RAmAuThYc4kwWVUfpMRLB+yXCYpUuu/xtbjpuliRlVq4pLYN964U1aPFjy7QfUQWs
         DJnyHIMsvwTw8n9a7WSVKxkgT55tF0fvKzI+vDemvwPAErejZYN1ecFjj1ge8eWwKjan
         I0DKWRYhWbtBfDTJ70kmwTJukd7cJXnZpwSn9pINgGftwQIuzyuAhElEEYxukJMCab9n
         G+xGW35x9e49+4AKudDq0wIPLVEO95hRvkEw4GjyJTyIArzWSK03bbVQkq9ttbG6/94r
         lAWjv9/km0P8bIagwy+SAK2+4ReNf78Qp55JgX2uI4Coug4yXPjs32DR0IvJqcIyAzDT
         GvOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730157239; x=1730762039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MjohkZCWItx1P1zaOWN8RLXGPxIli/Tp9Ueq+8PbQ1c=;
        b=RwHrqOzkS8slrmXFMkhEcy7gz7WyWulKez8LACS60XaDmFqM3dbuGfD9ZzOmqxjAoF
         ItZ4eVe9mIjUMah5zNQ21MXU6k3tZXxuCNvY70kF0NDANsrI1gslSp8/C9OitSakaZn1
         cQD4MR5BIed1AFHWXyY364RxV5rgzCmLjk47d8LAXEq3IRA57Cdhus0WQoVV7GGB4PAs
         TMMYHfqSYyyWa3a/Ty2HTV4you+SinB3ZfY/6bzq11vgWq6ZjiLohN2vYCN/xfqXOBk1
         gUEB520uR/6DHbTH4oD+QDrc3q8KhA5q8bSCLIdPvalRftQib+CJIVPj6M2DmsVZcLpV
         yDlw==
X-Forwarded-Encrypted: i=1; AJvYcCVntm0MjX7wWZWmA60C4L4iTeCwAigWhKcwHx+gNGzHiUC5sEH9xG0qP/Ao7GeXiK7GQYLZROyp4LO4gtYD@vger.kernel.org
X-Gm-Message-State: AOJu0YxkcbDZjJuJnRT4N9lPlIbnYkfHZlkNO79aYSttw9Nxzdb7zTa8
	yD0E5zImXaUlwGQysf5a2Wp96vdNBfWQUcXZjFrCnNMxiNPmlQm8VJxJjzEvqes=
X-Google-Smtp-Source: AGHT+IEKpYnlOXgqoRWlMC1TKuOxB2Oot8ftK1XXczcsnr8MX6gARhSGfX3uywNSPm6kipDP7tJ1wQ==
X-Received: by 2002:a17:902:d2d2:b0:20b:6d71:4140 with SMTP id d9443c01a7336-210c6c7354cmr111713295ad.44.1730157239473;
        Mon, 28 Oct 2024 16:13:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7edc89f2a2fsm6351987a12.73.2024.10.28.16.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 16:13:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t5Yvr-0077C6-14;
	Tue, 29 Oct 2024 10:13:55 +1100
Date: Tue, 29 Oct 2024 10:13:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
Subject: Re: lots of fstests cases fail on overlay with util-linux 2.40.2
 (new mount APIs)
Message-ID: <ZyAasz2RBpMpGV8T@dread.disaster.area>
References: <20241026180741.cfqm6oqp3frvasfm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241028-eigelb-quintessenz-2adca4670ee8@brauner>
 <20241028192804.axbj2onyoscgzvwi@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028192804.axbj2onyoscgzvwi@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Tue, Oct 29, 2024 at 03:28:04AM +0800, Zorro Lang wrote:
> On Mon, Oct 28, 2024 at 01:22:52PM +0100, Christian Brauner wrote:
> > On Sun, Oct 27, 2024 at 02:07:41AM +0800, Zorro Lang wrote:
> > > Hi,
> > > 
> > > Recently, I hit lots of fstests cases fail on overlayfs (xfs underlying, no
> > > specific mount options), e.g.
> > > 
> > > FSTYP         -- overlay
> > > PLATFORM      -- Linux/s390x s390x-xxxx 6.12.0-rc4+ #1 SMP Fri Oct 25 14:29:18 EDT 2024
> > > MKFS_OPTIONS  -- -m crc=1,finobt=1,rmapbt=0,reflink=1,inobtcount=1,bigtime=1 /mnt/fstests/SCRATCH_DIR
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /mnt/fstests/SCRATCH_DIR /mnt/fstests/SCRATCH_DIR/ovl-mnt
> > > 
> > > generic/294       [failed, exit status 1]- output mismatch (see /var/lib/xfstests/results//generic/294.out.bad)
> > >     --- tests/generic/294.out	2024-10-25 14:38:32.098692473 -0400
> > >     +++ /var/lib/xfstests/results//generic/294.out.bad	2024-10-25 15:02:34.698605062 -0400
> > >     @@ -1,5 +1,5 @@
> > >      QA output created by 294
> > >     -mknod: SCRATCH_MNT/294.test/testnode: File exists
> > >     -mkdir: cannot create directory 'SCRATCH_MNT/294.test/testdir': File exists
> > >     -touch: cannot touch 'SCRATCH_MNT/294.test/testtarget': Read-only file system
> > >     -ln: creating symbolic link 'SCRATCH_MNT/294.test/testlink': File exists
> > >     +mount: /mnt/fstests/SCRATCH_DIR/ovl-mnt: fsconfig system call failed: overlay: No changes allowed in reconfigure.
> > >     +       dmesg(1) may have more information after failed mount system call.
> > 
> > In the new mount api overlayfs has been changed to reject invalid mount
> > option on remount whereas in the old mount api we just igorned them.
> 
> Not only g/294 fails on new mount utils, not sure if all of them are from same issue.
> If you need, I can paste all test failures (only from my side) at here.
> 
> > If this a big problem then we need to change overlayfs to continue
> > ignoring garbage mount options passed to it during remount.
> 
> Do you mean this behavior change is only for overlayfs, doesn't affect other fs?

We tried this with XFS years ago, and reverted back to the old
behaviour of silently ignoring mount options we don't support in
remount. The filesystem code has no idea what mount API
userspace is using for remount - it can't assume that it is ok to
error out on unknown/unsupported options because it uses
the fsreconfigure API internally....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
