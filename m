Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB26A155A52
	for <linux-unionfs@vger.kernel.org>; Mon, 28 Oct 2024 19:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730143695; cv=none; b=h/SBiY3Plbz3Iem/C6k4kePoNnJehYPQDCob76xGd7hkMh2HBdm7mCRHLMJBdV+jnfkgN8ipqr8sn0Wzxe8QPeSMRK2y/AmJk3F+fzPrB6cqSmv9eqfTeajyQwvEOnl1JcAUXch7CuMFjYnhX2R7a5cCjOzkJkvWp97YPNvofn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730143695; c=relaxed/simple;
	bh=j+14TS//kHOonJXDSlHsg5yxoX/1kbRoS9Vqx8BZthM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PzMViZfnPGUkvTkBjm0pWGeX3ynZyrrhk9kdwd4qqZmae9xjljFoWWGdGOId28iObbciM2KTmgErmT8MsixffSUouzghblJIJxf3K2CffZDb/VX372PQhodo67nv+ZbnUUGNN2+8LmeNh6xE1kRJiOrr7rfUA/gliu76qVWeqfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fsgeq2EE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fsgeq2EE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730143691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t/vg+XHXZVanDLke+k+EmxatqkcqEswwCpL2oCHyW30=;
	b=fsgeq2EE0r8NybpBv7KuZ9NyFwC0k+fYexkGXlCn3q9r8jrerY/HDSG0bBuN9ouqQpXy50
	xS9OisX9iBaJ1KM+9yLUjuZ8rhqEkpnFqZiQDrc4oaMBb08qHOn7x7j/4Px5OdN5IbhO0m
	aR8HupoUo06Hk2KHjJwHCvYFA5V+T9A=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-vv3DCNIhOVSa268XKuN4xg-1; Mon, 28 Oct 2024 15:28:10 -0400
X-MC-Unique: vv3DCNIhOVSa268XKuN4xg-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-20e5df3e834so42826555ad.0
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Oct 2024 12:28:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730143689; x=1730748489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/vg+XHXZVanDLke+k+EmxatqkcqEswwCpL2oCHyW30=;
        b=wFHuhC/nKKbXc+FzEqJzo829Y9KC5vIz0AF0o4rPkaUT7pPXGjrPMSIknwFZoo2+Uy
         T/l0k/WHQm3q8o/G8ZvaeAOoNM6VtrXMqVG8ipLbAA7Vn14Kx5iuhiXaJJ2m1tR7zSIh
         8WebHVTjB+LNI+9cQ9n6FSjSuQr7yphssD+ceak7RK7BE5P3Kv+GZYTHUBRXBaTxHThl
         HjFQ39/x1pMgrDtH0Pl5O7WXDUoYcdBB2P5ylwMhpUh/dKA/rUHQ44YoOaW54LMQbHWt
         gFnj7WYmcY6A6bdMccK29NcqnEkTonXUspo/GDstb1ySJ/UGkPEZRoy6zSfWb0p7kZmn
         2ZLw==
X-Forwarded-Encrypted: i=1; AJvYcCWBrlP8g23Basq6XVWOEwyj5Im6qeo1cgD/nWuM53tv+4Joio9HAhk+3xXeZaJQXqIQ6mEOc09HJYGgNgSq@vger.kernel.org
X-Gm-Message-State: AOJu0YyucAm61V//VXt4hMYIGH/YHbIovk4khQRwu+uCmPu184lxQ+PY
	MHpUZ0IR2H7Eco5TdDCxn5u4nLsOq7TxwSMqQ2EsDUGbVxWoXe4MIHVAykI4hjzvXMHnTE/DgzX
	KBOwZIEQXU7o4UdbAXuiJknYkIKqhl7QcLQS1H3UnPjdZTHfCgAEh3AcgLv3qpJw=
X-Received: by 2002:a17:902:ec88:b0:20c:763e:d9cc with SMTP id d9443c01a7336-210c68a1a50mr158790095ad.7.1730143688970;
        Mon, 28 Oct 2024 12:28:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIyJYVfKmDvL0QgeiTuWSb9GK40uweku4lW5KWUkFjAIN30XxEgH4gQ/SGJU6rDFoTPP3d+Q==
X-Received: by 2002:a17:902:ec88:b0:20c:763e:d9cc with SMTP id d9443c01a7336-210c68a1a50mr158789875ad.7.1730143688627;
        Mon, 28 Oct 2024 12:28:08 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bc082597sm54116565ad.287.2024.10.28.12.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 12:28:08 -0700 (PDT)
Date: Tue, 29 Oct 2024 03:28:04 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
Subject: Re: lots of fstests cases fail on overlay with util-linux 2.40.2
 (new mount APIs)
Message-ID: <20241028192804.axbj2onyoscgzvwi@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241026180741.cfqm6oqp3frvasfm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241028-eigelb-quintessenz-2adca4670ee8@brauner>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028-eigelb-quintessenz-2adca4670ee8@brauner>

On Mon, Oct 28, 2024 at 01:22:52PM +0100, Christian Brauner wrote:
> On Sun, Oct 27, 2024 at 02:07:41AM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > Recently, I hit lots of fstests cases fail on overlayfs (xfs underlying, no
> > specific mount options), e.g.
> > 
> > FSTYP         -- overlay
> > PLATFORM      -- Linux/s390x s390x-xxxx 6.12.0-rc4+ #1 SMP Fri Oct 25 14:29:18 EDT 2024
> > MKFS_OPTIONS  -- -m crc=1,finobt=1,rmapbt=0,reflink=1,inobtcount=1,bigtime=1 /mnt/fstests/SCRATCH_DIR
> > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /mnt/fstests/SCRATCH_DIR /mnt/fstests/SCRATCH_DIR/ovl-mnt
> > 
> > generic/294       [failed, exit status 1]- output mismatch (see /var/lib/xfstests/results//generic/294.out.bad)
> >     --- tests/generic/294.out	2024-10-25 14:38:32.098692473 -0400
> >     +++ /var/lib/xfstests/results//generic/294.out.bad	2024-10-25 15:02:34.698605062 -0400
> >     @@ -1,5 +1,5 @@
> >      QA output created by 294
> >     -mknod: SCRATCH_MNT/294.test/testnode: File exists
> >     -mkdir: cannot create directory 'SCRATCH_MNT/294.test/testdir': File exists
> >     -touch: cannot touch 'SCRATCH_MNT/294.test/testtarget': Read-only file system
> >     -ln: creating symbolic link 'SCRATCH_MNT/294.test/testlink': File exists
> >     +mount: /mnt/fstests/SCRATCH_DIR/ovl-mnt: fsconfig system call failed: overlay: No changes allowed in reconfigure.
> >     +       dmesg(1) may have more information after failed mount system call.
> 
> In the new mount api overlayfs has been changed to reject invalid mount
> option on remount whereas in the old mount api we just igorned them.

Not only g/294 fails on new mount utils, not sure if all of them are from same issue.
If you need, I can paste all test failures (only from my side) at here.

> If this a big problem then we need to change overlayfs to continue
> ignoring garbage mount options passed to it during remount.

Do you mean this behavior change is only for overlayfs, doesn't affect other fs?

If it's not necessary, I think we'd better to not change the behaviors which we've
used so many years. But if you all agree with this change, then we need to update
related regression test cases and more scripts maybe.

Thanks,
Zorro

> 

