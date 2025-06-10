Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCA8246765;
	Tue, 10 Jun 2025 18:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578451; cv=none; b=oplv/SiqAcc6nbZNsTwyY2MSCqMPVn0IXXWmWDh1mHL6uCoMvxj8zyk23g4CcA16c7wRVunGjypuFYkKS5oVVxmrQGLzTGpfTJ3hk31I0isbDzz3h6EEYFiqKsavomLmjcbNWj616MLiJdgMNLHsdOzyHbKSuCDeDJ0nwdsjPyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578451; c=relaxed/simple;
	bh=0Jbq+VMZ6ng7MYUkjT6m1G40oEEr6FlFZip5IlndPB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UjnQjDDFg5opyvR1vNH/A8xhkG7P5FQG6U/GK3JcEEuNb4BGYJYjBilfU33jWhSdhMRMfSdEM2eYEkAD+ADakTHrLjLH7elvVX6p6AluOJqDLQZojDrA8tnLNhHcP1YH0BntRLhjYSfUZAmta3MGcBF0sJBQchbV5N4N+PkDtMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=NFaEfs7N; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="NFaEfs7N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9E/oNEj68bBOMaJBb8T9GOJkzbT08eXCLJgWVqOqHPg=; b=NFaEfs7N8L64Y+IzVvyFU/bNHp
	zge7mSxD1A/1vjd88xLqDu0kp7fbXLqVje/dwPx+XA2j8tPU+BJJE4YmrXCAOv2fz9dreRwmpJxVP
	2p/h+JK+crGFIH4RqtNK9TZ7NK/CK8tVuxNByGxwFEb9XVBAxrXBfISkKv6xzc2BPhqPYucKpDLL8
	6u4yF66y1oh8sWsHST1Sy6rNxeRFBUqrd9JVVJVW1DvHn9mWajOP9uHAYUKRAoEtpdsNWL2CpC/9r
	hqIYeAR7GOAKwj4WA5X+r9BZiyI4lTCKijfqHyQ/7sLfbJn5vnhFkJmXylevgo6tVVRpV1nL6R75L
	O16iPv3g==;
Received: from [191.204.192.64] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1uP3H2-001uaH-Nq; Tue, 10 Jun 2025 20:00:36 +0200
Message-ID: <d24bba45-681c-4446-aa7e-b020889aeaf6@igalia.com>
Date: Tue, 10 Jun 2025 15:00:33 -0300
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] fstests overlay updates for 6.16-rc1
To: Amir Goldstein <amir73il@gmail.com>, Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner
 <brauner@kernel.org>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
References: <20250609151915.2638057-1-amir73il@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <20250609151915.2638057-1-amir73il@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Amir,

Em 09/06/2025 12:19, Amir Goldstein escreveu:
> Zorro,
> 
> Please find two new tests by Miklos to cover ian overlayfs feature
> merged to 6.16-rc1. Those tests do notrun on older kernels.

Using this patchset on top of 6.16-rc1 I still found that overlay/012 
still doesn't work in my setup:

$ sudo FSTYPE=ext4 TEST_DIR=/tmp/dir1 TEST_DEV=/dev/vdb 
SCRATCH_DEV=/dev/vdc SCRATCH_MNT=/tmp/dir2 ./check -overlay overlay/012
...
     -rm: cannot remove 'SCRATCH_MNT/test': Stale file handle
     +rm: cannot remove 'SCRATCH_MNT/test': Is a directory

Here's a smaller reproducer for 012:

```
mkdir -p /tmp/dir2/ovl-lower/test /tmp/dir2/ovl-upper /tmp/dir2/ovl-work 
tmp/dir2/ovl-mnt

sudo mount -t overlay 
-olowerdir=/tmp/dir2/ovl-lower,upperdir=/tmp/dir2/ovl-upper,workdir=/tmp/dir2/ovl-work 
/tmp/dir2 /tmp/dir2/ovl-mnt

rmdir /tmp/dir2/ovl-mnt/test
touch /tmp/dir2/ovl-mnt/test
rm /tmp/dir2/ovl-upper/test
# rm /tmp/dir2/ovl-mnt/test (bug happens here)
```

Before executing the last line, if you run ls you can see that test is a 
file:

$ ls -la dir2/ovl-mnt/test
-rw-r--r-- 0 user user 0 Jun 10 17:54 dir2/ovl-mnt/test

After trying to remove the file, the previous ls command is empty now:

$ rm dir2/ovl-mnt/test
rm: cannot remove 'dir2/ovl-mnt/test': Is a directory
$ ls -la dir2/ovl-mnt/test
total 0
drwxr-xr-x 2 user user 40 Jun 10 17:54 .
drwxr-xr-x 1 user user 40 Jun 10 17:55 ..

But running it in a upper level shows the file as a directory:

$ ls -la dir2/ovl-mnt/
total 0
drwxr-xr-x 1 user user  40 Jun 10 17:55 .
drwxr-xr-x 6 user user 120 Jun 10 17:54 ..
drwxr-xr-x 2 user user  40 Jun 10 17:54 test


