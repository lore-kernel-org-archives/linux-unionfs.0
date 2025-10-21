Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C99238C0F
	for <linux-unionfs@vger.kernel.org>; Tue, 21 Oct 2025 01:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761009428; cv=none; b=uLipZdez4mDlpaXpV+8CUNar9VHSL8+DIVmF8E2xd7jEVdixnWALcIqY/0E2YQvmz5/qVHLHIBc6nV+bw5ZtlHsuI3moyioMn6S0HUwB67eddYS5xDAN6sJJmsIe+dc2RqtmkdoTRjlJJWunEuUjLvjLy+AYNH4hXq+IWSVoJsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761009428; c=relaxed/simple;
	bh=1zeq0Q49NwqRZRi1E4alBbjTRuUASN/N0O5LnU4lOx0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FRDOv8DsTXdUuwn3AvLZ2uExwlTwYDY0doKQiVSKNvfy1tHxAoBCW6qeAnB/7FbPhgbXHm2NGvbXHN1ot6JGwOgN9u3utIBheIZZcEOclhZaQFQoLAqfk6s1aa1r+m2rKFIeCwJEQklE+exTMLPAzVSjfF1xwD0midUYPn+5dxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ROZaTbP1; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ROZaTbP1"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b62e7221351so4126494a12.1
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Oct 2025 18:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761009424; x=1761614224; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R+jF/m5GxGdkV4M8f/uDqVu8BkqXyzon9JTL3m8pZ6o=;
        b=ROZaTbP1pn6Y2KnIsOPHrzTyoA7Y5eZI6Srq1vdmuQNHzPJXBLHIwCTHESCjTpZRNe
         m/utNBS/cKhxxTn5R/ZcGCGXPiZoqCiMM6g6qt+LmA9/sjMjOGiGWIscgipTTZ/q1YEn
         2L3TsK3jI3C7iTBAaIgyUGkXzOvfSIhz31epbC0TSNFDuJQX4zGgPTbBt5nX4JzLAxVM
         Jp683rCVCzazya4SiDi2YoubHd4XL5hGTaM6wFBnW/8j/QmD5m08TEUfM2xtKbK/4Lzv
         PXWYcAkdMy9cHHk+pBc8TpX9dujskQnrZ7ZKNeRpvGuJf0GAfW86quQjpO52tx5ctS+B
         jgmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761009424; x=1761614224;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R+jF/m5GxGdkV4M8f/uDqVu8BkqXyzon9JTL3m8pZ6o=;
        b=tJzEoDnXjnG5vmLtBb0VRPX7VJRh69GKlcy4Cn7OZC4E6Zut299X4TfBqWXDdxnF1F
         52fWuIKMA7DBk4ZsXqP/Ev4nMko0eK2UMDK/5eyd7XVK7a6aldG5FEe3mTTfjVHp288d
         W1J41q0KdDY7oR7IzZBZtfcYL1mbcOPyEmIMN76IyFkhoba8PGBKgYjeB7/R6/sYWjLm
         J6rN3ZC1xBz8mqykTgagPNDgCuWVBb+4YyVAgVLVEP4tk8mCCClQjX7soFFTpstSs1yA
         fjWJO51gBtSPmpac8QD3Y6uh8YEL341/Kw2DGZQC4lyN1NDQt6aGDEM6QivE+sAO7N8S
         2DCA==
X-Forwarded-Encrypted: i=1; AJvYcCVIVUcsJIP8VfeSUNTICWMZt4sgoROP7+DF+x5n7GfZVIA5x5a0RKabgNtvxJvqstmDZHa42TNRwXfNEXZi@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1YwSOVXlpy3lAp7uJJ+Ntf+n44XtcaYm54Ob62hg6N1xVFyVx
	u6G4Kdz6Kk1iIqw5pRGl6q5KTYGU3hn9I1Dz6i/W/YGxIrK/40yHsSRw
X-Gm-Gg: ASbGnct3CtZ6tnYsPrWAQbTUDg8KM/5JtrxIaLik7USVnO7rIrHCEMHbd4OAFh6NXCU
	dmhouVfk7GgGqkqtR+Sxriwq3nGnyE6ovAa2HqzN9XsLQqjfGbr5Y4RU8I+bCtz/2Qwnoik4CTu
	Z/dk/y5as5iI14qFdIa5wnqLhmiQ6eJMDDJzlzHMpcwEdwtNp6lZYTgQhRPPl60tUnTYcDFrzwS
	qt4lHR4DlrBEVShp1/dumSKm7OCH9g1Bt4B+PNNN7o92vs0R02OYak6iYerDv9Kg9YjTNZZLgcK
	PVaMEg+rq8POa1zZ7k0CiZ5L8ybffY4ff7EGb7CgJMep1ZI3Q69OGg5x7LdOu5JxlKHH4CnY+ng
	4wB7zhT7McPT0McJSDoltgZCXZpBqVSMZFgOUAwp33Uqp7n0qgk2x3ply4KQ4YIIJk4NOxbp4YY
	gVsoXzI/ERf0ykV3DESYsS8IsX1L5eflXeaz1ILYv9PyRgz+mA+x4PkMwxFeD1ygKlj+0V
X-Google-Smtp-Source: AGHT+IFz7BMEyiUbDQVbe7h7z/q786244belk8+vOd3hqwr5CAeeHL/XEJmuhApsPJjkKQZ+v/uU9A==
X-Received: by 2002:a05:6a21:7914:b0:334:bec2:5b63 with SMTP id adf61e73a8af0-334bec25e36mr9995666637.24.1761009423608;
        Mon, 20 Oct 2025 18:17:03 -0700 (PDT)
Received: from [192.168.50.88] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff34e72sm9658662b3a.24.2025.10.20.18.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 18:17:03 -0700 (PDT)
Message-ID: <195761a4-0251-4e9f-a896-018ff20e1643@gmail.com>
Date: Tue, 21 Oct 2025 09:16:59 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] ovl: Use fsid as unique identifier for trusted
 origin
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
 =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 kernel-dev@igalia.com, Miklos Szeredi <miklos@szeredi.hu>,
 Amir Goldstein <amir73il@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, "Guilherme G . Piccoli"
 <gpiccoli@igalia.com>
References: <20251014015707.129013-1-andrealmeid@igalia.com>
 <20251014015707.129013-2-andrealmeid@igalia.com>
 <aO3T8BGM6djYFyrz@infradead.org>
 <5137ce36-c3b4-4a0a-83af-e00892feaf43@gmail.com>
 <aPas60j7AoyLLQK0@dread.disaster.area>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <aPas60j7AoyLLQK0@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 21/10/25 05:43, Dave Chinner wrote:
> On Wed, Oct 15, 2025 at 07:46:34AM +0800, Anand Jain wrote:
>> On 14-Oct-25 12:39 PM, Christoph Hellwig wrote:
>>> On Mon, Oct 13, 2025 at 10:57:07PM -0300, André Almeida wrote:
>>>> Some filesystem have non-persistent UUIDs, that can change
>>>> between mounting, even if the filesystem is not modified. To
>>>> prevent false-positives when mounting overlayfs with index
>>>> enabled, use the fsid reported from statfs that is persistent
>>>> across mounts.
>>>
>>> Please fix btrfs to not change uuids, as that completely defeats
>>> the point of uuids.
>>
>> We needed cloned device mount support for an A/B testing use case,
>> but changing the on-disk UUID defeats the purpose.
>>
>> Right now, ext4 and Btrfs can mount identical devices, but XFS
>> can't.
> 
> Absolutely not true.
> 
> XFS has been able to mount filesystems with duplicate UUIDs on Linux
> for almost 25 years. The "-o nouuid" mount option (introduced in
> 2001) to bypass the duplicate uuid checks done at mount time.
> 

Damn, I completely missed the nouuid XFS option. My bad!!
> XFS tracks all mounted filesystem UUIDs largely to prevent multiple
> mounts of the same filesystem due to multipath storage presenting it
> via multiple different block devices.
 > > The nouuid mount option was added back when enterprise storage
> arrays started supporting hardware level thinp and LUN
> clone/snapshot functionality. Adding "-o nouuid" allowed cloned LUNs
> to be mounted for for backup/recovery purposes whilst the main
> filesystem was still mounted and in active use.
> 

Agree. Also, in some SAN error situations, the same device may
disappear and reappear with a new maj:min.

>> How about extending this to the common
>> VFS layer and adding a parameter to tell apart a cloned
>> device from the same device accessed through multiple
>> paths?
> 
> Perhaps we should lift the XFS UUID tracking code to the VFS
> and intercept "-o nouuid" at the VFS to allow duplicates only when
> that mount option is set?
> 
> -Dave.

It looks like XFS (with -o nouuid) and ext4 allow duplicate
FSIDs to pass into VFS. We may be able to extend this to Btrfs,
though there could be conflicts with fanotify? I'm not sure yet.
we still need -o nouuid, to alert admins to handle cases where a
device reappears with a new devt. I'm digging more.

Thanks, Anand
