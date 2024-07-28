Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B3B22616
	for <linux-unionfs@vger.kernel.org>; Sun, 28 Jul 2024 20:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722198803; cv=none; b=rbPhRc0mU5Ix5REthRWT+LhDNF2D+Jud28tFSzhYgK2qU1T5vKeJwzvcyVYLwyRSaW/G0I1CETmKadoBNL6XUTdpgjtyEqKCE1uZ4gVzD9i8VGtfivywtAiy2yWUdpvVK+JTg/pmRFkn0T7darK+CaY0U/bA7pMr1QJ48p810Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722198803; c=relaxed/simple;
	bh=s4Jp/ePoR4ARB63K9SnUzx/MA2YrvKJq4lYpaUqIWDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jy/8lGGYbmai7rHhrawchEsHXq1gTrzniPlo4id0oGY4QC0JLpAV52oeO9kO7jpOgczv5BCz7fN+QsQubVOYqxTHic86KHrZZPHdfScFI1siW1zMr879dwMsNhM6jD/t0JMKzrtHVVJDfa9XC0Eengoz3bHHhQvETYF4TSMR8qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=fqlN+Hp9; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="fqlN+Hp9"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-65cd720cee2so13191657b3.1
        for <linux-unionfs@vger.kernel.org>; Sun, 28 Jul 2024 13:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1722198800; x=1722803600; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ddLzH1s1ItYDjcGSY95QI0nrn8Vsq7TdmiYr7oRhb3o=;
        b=fqlN+Hp9oW+pWr7p6TjlE+2wS6T2zZ/IjWGKgqi+8pHuJU8oZuNIu5Rem6H2Bl+lmh
         FCNR1NcR2wTb92FThrjsRCCf2q7fyEYSpwzGVyq1PoqT0qav2Xeph4p1pXvQEDNxJmOa
         b1HP/R1Koma3+/6hfR1pDSx+BqFN0zft2crue0tB4I3I4/jji+fb6Q8QsOZkMFCbsSA0
         CFoM5souGD5dHjJoMKImabTDHJT9G3gzJJC9kny/TQQFRSYDmUYDIybY7ImC94w+jpDO
         /CAhJDxKaDVZBnSNWnvGqMObbGvT27BhfSI60V9oJHqbG3KgSKALOg/JKohyIC+8/nS4
         6Dyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722198800; x=1722803600;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ddLzH1s1ItYDjcGSY95QI0nrn8Vsq7TdmiYr7oRhb3o=;
        b=YF0Bsjotos+L7jddMRz7JTaITs4KFfH23fOzApHKghLzglLXBpSdWr+V7b2gAaYico
         ZevKRViwWI5A8cFw9L/pUnu0F9AzwyNQuKF913E06zbuZmaVVSB/fMNtV7z+xUuH75zi
         qP5RW8xaGTSYlRXOzogFsRDWdznIFgn7kGsOHDE/7QOJJLN+o38DrjukHEzdqRYaUHuV
         qTWTnSj9f7pB7uML8QRA1Z39WVhEK/xrTnRkcEBtWp+PH1W0QTJEtXf1iayD0zdnM7BZ
         hPaPoNI5GI6HjItR0nqdxvHnCFpb+Eb2V9SOp6m5XW22De6777tuM2bA7W5eAR3zfxKF
         4ryw==
X-Forwarded-Encrypted: i=1; AJvYcCW2VwMR6QUfgLDSmkxu936U8Ajs5mpjipHYCdjOcJlSyh+DtrhFI7uq+KvRqY7GEZiHSnaCI1sgzFF3SJw+ZWcwqixPmUIpDZQ93Fd20A==
X-Gm-Message-State: AOJu0YyKDTs7LmrMdZ5s+Un9IFVYOALQE8QISbwa+NStxmHIQhiw4nRs
	w4EFZEH96/RR7gOhJotczuxG8kpCnWwo4olYAM8aGVccZRGykaic3y1eSR/buOI=
X-Google-Smtp-Source: AGHT+IEPexF9kXaAQz9FaR+UnF7n5GYrAPFQSMQaYnp5FxZsatNbj+Qcx0YLkZMqXulXaBOQw/EwJw==
X-Received: by 2002:a81:a210:0:b0:63b:f8cb:9281 with SMTP id 00721157ae682-67a0a8f2ad2mr55526247b3.41.1722198799974;
        Sun, 28 Jul 2024 13:33:19 -0700 (PDT)
Received: from ?IPV6:2600:381:5f08:4761:2406:c2ca:972c:5028? ([2600:381:5f08:4761:2406:c2ca:972c:5028])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6756bab5090sm17705887b3.120.2024.07.28.13.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jul 2024 13:33:19 -0700 (PDT)
Message-ID: <91e8c240-ed60-40ab-8c55-f06347e26841@mbaynton.com>
Date: Sun, 28 Jul 2024 15:33:16 -0500
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>
Cc: Daire Byrne <daire@dneg.com>, overlayfs <linux-unionfs@vger.kernel.org>
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
 <f1ed1b60-273d-4ee6-bbcb-ae3d78486b70@mbaynton.com>
 <CAOQ4uxiSm0Le4dYx_R2WPmF9Ut8z6eZinN-qvDrG+Y2GnX11fg@mail.gmail.com>
 <9237a062-4f91-4d32-be19-b7bdd7d71bfe@mbaynton.com>
 <CAOQ4uxhMbzvmoYS1x0DdaNm+BvkQ7+7mdmsA2XpiVXGO2Fgvbg@mail.gmail.com>
Content-Language: en-US
From: Mike Baynton <mike@mbaynton.com>
In-Reply-To: <CAOQ4uxhMbzvmoYS1x0DdaNm+BvkQ7+7mdmsA2XpiVXGO2Fgvbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/21/24 22:31, Amir Goldstein wrote:
> 
> 
> On Mon, Jul 22, 2024, 6:02 AM Mike Baynton <mike@mbaynton.com 
> <mailto:mike@mbaynton.com>> wrote:
> 
> On 7/12/24 04:09, Amir Goldstein wrote:
>> On Fri, Jul 12, 2024 at 6:24 AM Mike Baynton <mike@mbaynton.com
> <mailto:mike@mbaynton.com>> wrote:
>>> 
>>> On 7/11/24 18:30, Amir Goldstein wrote:
>>>> On Thu, Jul 11, 2024 at 6:59 PM Daire Byrne <daire@dneg.com
> <mailto:daire@dneg.com>> wrote:
>>>>> Basically I have a read-only NFS filesystem with software
>>>>> releases that are versioned such that no files are ever
>>>>> overwritten or
> changed.
>>>>> New uniquely named directory trees and files are added from
>>>>> time to time and older ones are cleaned up.
>>>>> 
>>>> 
>>>> Sounds like a common use case that many people are interested
>>>> in.
>>> 
>>> I can vouch that that's accurate, I'm doing nearly the same
> thing. The
>>> properties of the NFS filesystem in terms of what is and is not
> expected
>>> to change is identical for me, though my approach to
>>> incorporating overlayfs has been a little different.
>>> 
>>> My confidence in the reliability of what I'm doing is still far
>>> from absolute, so I will be interested in efforts to
>>> validate/officially sanction/support/document related
>>> techniques.
>>> 
>>> The way I am doing it is with NFS as a data-only layer.
>>> Basically
> my use
>>> case calls for presenting different views of NFS-backed data
>>> (it's software libraries) to different applications. No
>>> application
> wants or
>>> needs to have the entire NFS tree exposed to it, but each
>>> application wants to use some data available on NFS and wants it
>>> to be
> presented in
>>> some particular local place. So I actually wanted a method where
>>> I author a metadata-only layer external to overlayfs, built to
>>> spec.
>>> 
>>> Essentially it's making overlayfs redirects be my symlinks so
> that code
>>> which doesn't follow symlinks or is otherwise influenced by them
> is none
>>> the wiser.
>>> 
>> 
>> Nice. I've always wished that data-only would not be an
>> "offline-only"
> feature,
>> but getting the official API for that scheme right might be a
> challenge.
>> 
>>>>> My first question is how bad can the "undefined behaviour"
>>>>> be
> in this
>>>>> kind of setup?
>>>> 
>>>> The behavior is "undefined" because nobody tried to define it, 
>>>> document it and test it. I don't think it would be that "bad",
>>>> but it will be unpredictable and is not very nice for a
>>>> software product.
>>>> 
>>>> One of the current problems is that overlayfs uses readdir
>>>> cache the readdir cache is not auto invalidated when lower dir
>>>> changes so whether or not new subdirs are observed in overlay
>>>> depends on whether the merged overlay directory is kept in
>>>> cache or not.
>>>> 
>>> 
>>> My approach doesn't support adding new files from the data-only
>>> NFS layer after the overlayfs is created, of course, since the
> metadata-only
>>> layer is itself the first lower layer and so would presumably
>>> get
> into
>>> undefined-land if added to. But this arrangement does probably 
>>> mitigate this problem. Creating metadata inodes of a fixed set
>>> of libraries for a specific application is cheap enough (and
> considerably
>>> faster than copying it all locally) that the immutablity
>>> limitation works for me.
>>> 
>> 
>> Assuming that this "effectively-data-only" NFS layer is never
> iterated via
>> overlayfs then adding new unreferenced objects to this layer
> should not
>> be a problem either.
>> 
>>>>> Any files that get copied up to the upper layer are 
>>>>> guaranteed to never change in the lower NFS filesystem (by
>>>>> it's design), but new directories and files that have not yet
>>>>> been
> copied
>>>>> up, can randomly appear over time. Deletions are not so
>>>>> important because if it has been deleted in the lower level,
>>>>> then the upper level copy failing has similar results (but we
>>>>> should cleanup the upper layer too).
>>>>> 
>>>>> If it's possible to get over this first difficult hurdle,
>>>>> then
> I have
>>>>> another extra bit of complexity to throw on top - now
>>>>> manually
> make an
>>>>> entire directory tree (of metdata) that we have recursively
> copied up
>>>>> "opaque" in the upper layer (currently needs to be done
>>>>> outside of overlayfs). Over time or dropping of caches, I
>>>>> have found that this (seamlessly?) takes effect for new
>>>>> lookups.
>>>>> 
>>>>> I also noticed that in the current implementation, this
>>>>> "opaque" transition actual breaks access to the file because
>>>>> the metadata copy-up sets "trusted.overlay.metacopy" but does
>>>>> not currently
> add an
>>>>> explicit "trusted.overlay.redirect" to the correspnding lower
>>>>> layer file. But if it did (or we do it manually with
>>>>> setfattr), then
> it is
>>>>> possible to have an upper level directory that is opaque,
>>>>> contains file metadata only and redirects to the data to the
>>>>> real files
> on the
>>>>> lower NFS filesystem.
>>> 
>>> So once you use opaque dirs and redirects on an upper layer,
>>> it's sounding very similar to redirects into a data-only layer.
>>> In either case you're responsible for producing metadata inodes
>>> for each
> NFS file
>>> you want presented to the application/user.
>>> 
>> 
>> Yes, it is almost the same as data-only layer. The only difference
>> is that real data-only layer can never be accessed directly from
>> overlay, while the effectively-data-only layer must have some path
>> (e.g /blobs) accessible directly from overlay in order to do online
>> rename of blobs into the upper opaque layer.
>> 
>>> This way seems interesting and more promising for adding
>>> NFS-backed files "online" though.
>>> 
>>>> how can we document it to make the behavior "defined"?
>>>> 
>>>> My thinking is:
>>>> 
>>>> "Changes to the underlying filesystems while part of a mounted
> overlay
>>>> filesystem are not allowed.  If the underlying filesystem is
> changed,
>>>> the behavior of the overlay is undefined, though it will not
> result in
>>>> a crash or deadlock.
>>>> 
>>>> One exception to this rule is changes to underlying filesystem
> objects
>>>> that were not accessed by a overlayfs prior to the change. In
>>>> other words, once accessed from a mounted overlay filesystem, 
>>>> changes to the underlying filesystem objects are not allowed."
>>>> 
>>>> But this claim needs to be proved and tested (write tests), 
>>>> before the documentation defines this behavior. I am not even
>>>> sure if the claim is correct.
>>> 
>>> I've been blissfully and naively assuming that it is based on
> intuition
>>> :).
>> 
>> Yes, what overlay did not observe, overlay cannot know about. But
>> the devil is in the details, such as what is an "accessed 
>> filesystem object".
>> 
>> In our case study, we refer to the newly added directory entries 
>> and new inodes "never accessed by overlayfs", so it sounds safe to
>> add them while overlayfs is mounted, but their parent
> directory,
>> even if never iterated via overlayfs was indeed accessed by
>> overlayfs (when looking up for existing siblings), so overlayfs did
>> access the lower parent directory and it does reference the lower
>> parent directory dentry/inode, so it is still not "intuitively"
>> safe to
> change it.

This makes sense. I've been sure to cause the directory in the data-only
layer that subsequently experiences an "append" to be consulted to
lookup a different file before the append.

>> 
>>> 
>>> I think Daire and I are basically only adding new files to the
>>> NFS filesystem, and both the all-opaque approach and the
>>> data-only
> approach
>>> could prevent accidental access to things on the NFS filesystem
> through
>>> the overlayfs (or at least portion of it meant for end-user
> consumption)
>>> while they are still being birthed and might be experiencing
>>> changes. At some point in the NFS tree, directories must be
>>> modified, but
> since
>>> both approaches have overlayfs sourcing all directory entries
> from local
>>> metadata-only layers, it seems plausible that the directories
>>> that change aren't really "accessed by a overlayfs prior to the
>>> change."
>>> 
>>> How much proving/testing would you want to see before
>>> documenting
> this
>>> and supporting someone in future who finds a way to prove the
>>> claim wrong?
>>> 
>> 
>> *very* good question :)
>> 
>> For testing, an xfstest will do - you can fork one of the existing 
>> data-only tests as a template>
> Due to the extended delay in a substantive response, I just wanted
> to send a quick thank you for your reply and suggestions here. I am
> still interested in pursuing this, but I have been busy and then
> recovering from illness.
> 
> I'll need to study how xfstest directly exercises overlayfs and how
> it is combined with unionmount-testsuite I think.
> 
> 
> Running unionmount-testsuite from fstests is optional not a must for 
> developing an fastest.
> 
> See README.overlay in fstests for quick start With testing overlays.
> 
> Thanks, Amir.
> 
> 
>> 
>> For documentation, I think it is too hard to commit to the general 
>> statement above.
>> 
>> Try to narrow the exception to the rule to the very specific use
>> case of "append-only" instead of "immutable" lower directory and
>> then state that the behavior is "defined" - the new entries are
>> either
> visible
>> by overlayfs or they are not visible, and the "undefined" element 
>> is *when* they become visible and via which API (*).
>> 
>> (*) New entries may be visible to lookup and invisible to readdir 
>> due to overlayfs readdir cache, and entries could be visible to 
>> readdir and invisible to lookup, due to vfs negative lookup
> cache.

So I've gotten a test going that focuses on really just two behaviors
that would satisfy my use case and that seem to currently be true.
Tightening the claims to a few narrow -- and hopefully thus needing
little to no effort to support -- statements seems like a good idea to
me, though in thinking through my use case, the behaviors I attempt to
make defined are a little different from how I read the idea above. That
seems to be inclusive of regular lower layers, where files might or
might not be accessible through regular merge. It looks like your
finalize patch is more oriented towards establishing useful defined
behaviors in case of modifications to regular lower layers, as well as
general performance. I thought I could probably go even simpler.

Because I simply want to add new software versions to the big underlying
data-only filesystem periodically but am happy to create new overlayfs
mounts complete with new "middle"/"redirect" layers to the new versions,
I just focus on establishing the safety of append-only additions to a
data-only layer that's part of a mounted overlayfs.
The only real things I need defined are that appending a file to the
data-only layer does not create undefined behavior in the existing
overlayfs, and that the newly appended file is fully accessible for
iteration and lookup in a new overlayfs, regardless of the file access
patterns through any overlayfs that uses the data-only filesystem as a
data-only layer.

The defined behaviors are:
 * A file added to a data-only layer while mounted will not appear in
   the overlayfs via readdir or lookup, but it is safe for applications
   to attempt to do so.
 * A subsequently mounted overlayfs that includes redirects to the added
   files will be able to iterate and open the added files.

So the test is my attempt to create the least favorable conditions /
most likely conditions to break the defined behaviors. Of course testing
for "lack of undefined" behavior is open-ended in some sense. The test
conforms to the tightly defined write patterns, but since we don't
restrict the read patterns against overlayfs there might be other
interesting cases to validate there.

I suppose the eventual place for this would be the fstests mailing list
but I was hoping you might be able to comment on the viability of making
these defined first. I'm also definitely open to suggestions to
strengthen the test.

Many thanks,
Mike

---
 tests/overlay/087     | 169 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/087.out |  13 ++++
 2 files changed, 182 insertions(+)
 create mode 100755 tests/overlay/087
 create mode 100644 tests/overlay/087.out

diff --git a/tests/overlay/087 b/tests/overlay/087
new file mode 100755
index 00000000..636211a0
--- /dev/null
+++ b/tests/overlay/087
@@ -0,0 +1,169 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc. All Rights Reserved.
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+# Copyright (C) 2024 Mike Baynton. All Rights Reserved.
+#
+# FS QA Test 087
+#
+# Tests limited defined behaviors in case of additions to data-only layers
+# while participating in a mounted overlayfs.
+#
+. ./common/preamble
+_begin_fstest auto quick metacopy redirect
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs overlay
+# We use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
+_require_scratch_overlay_features redirect_dir metacopy
+_require_scratch_overlay_lowerdata_layers
+_require_xfs_io_command "falloc"
+
+# remove all files from previous tests
+_scratch_mkfs
+
+# File size on lower
+dataname="d1/datafile"
+datacontent="data"
+dataname2="d2/datafile2"
+datacontent2="data2"
+datasize="4096"
+
+# Check size
+check_file_size()
+{
+	local target=$1 expected_size=$2 actual_size
+
+	actual_size=$(_get_filesize $target)
+
+	[ "$actual_size" == "$expected_size" ] || echo "Expected file size
$expected_size but actual size is $actual_size"
+}
+
+check_file_contents()
+{
+	local target=$1 expected="$2"
+	local actual target_f
+
+	target_f=`echo $target | _filter_scratch`
+
+	read actual<"$target"
+
+	[ "$actual" == "$expected" ] || echo "Expected file $target_f contents
to be \"$expected\" but actual contents are \"$actual\""
+}
+
+check_file_size_contents()
+{
+	local target=$1 expected_size=$2 expected_content="$3"
+
+	check_file_size $target $expected_size
+	check_file_contents $target "$expected_content"
+}
+
+create_basic_files()
+{
+	_scratch_mkfs
+	# create a few different directories on the data layer
+	mkdir -p "$datadir/d1" "$datadir/d2" "$lowerdir" "$upperdir" "$workdir"
+	echo "$datacontent" > $datadir/$dataname
+	chmod 600 $datadir/$dataname
+	echo "$datacontent2" > $datadir/$dataname2
+	chmod 600 $datadir/$dataname2
+
+	# Create files of size datasize.
+	for f in $datadir/$dataname $datadir/$dataname2; do
+		$XFS_IO_PROG -c "falloc 0 $datasize" $f
+		$XFS_IO_PROG -c "fsync" $f
+	done
+}
+
+mount_overlay()
+{
+	_overlay_scratch_mount_opts \
+		-o"lowerdir=$lowerdir::$datadir" \
+		-o"upperdir=$upperdir,workdir=$workdir" \
+		-o redirect_dir=on,metacopy=on
+}
+
+umount_overlay()
+{
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+prepare_midlayer()
+{
+	_scratch_mkfs
+	create_basic_files
+	# Create midlayer
+	_overlay_scratch_mount_dirs $datadir $lowerdir $workdir -o
redirect_dir=on,index=on,metacopy=on
+	# Trigger metacopy and redirect xattrs
+	mv "$SCRATCH_MNT/$dataname" "$SCRATCH_MNT/file1"
+	mv "$SCRATCH_MNT/$dataname2" "$SCRATCH_MNT/file2"
+	umount_overlay
+}
+
+# Create test directories
+datadir=$OVL_BASE_SCRATCH_MNT/data
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+
+echo -e "\n== Create overlayfs and access files in data layer =="
+#set -x
+prepare_midlayer
+mount_overlay
+
+check_file_size_contents "$SCRATCH_MNT/file1" $datasize $datacontent
+# iterate some dirs through the overlayfs to populate caches
+ls $SCRATCH_MNT > /dev/null
+ls $SCRATCH_MNT/d1 > /dev/null
+
+echo -e "\n== Add new files to data layer, online and offline =="
+
+f="$OVL_BASE_SCRATCH_MNT/birthing_file"
+echo "new file 1" > $f
+chmod 600 $f
+$XFS_IO_PROG -c "falloc 0 $datasize" $f
+$XFS_IO_PROG -c "fsync" $f
+# rename completed file under mounted ovl's data dir
+mv $f $datadir/d1/newfile1
+
+newfile1="$SCRATCH_MNT/d1/newfile1"
+newfile2="$SCRATCH_MNT/d1/newfile2"
+# Try to open some files that will exist in future
+read <"$newfile1" 2>/dev/null || echo "newfile1 expected missing"
+read <"$newfile2" 2>/dev/null || echo "newfile2 expected missing"
+
+umount_overlay
+
+echo "new file 2" > "$datadir/d1/newfile2"
+chmod 600 "$datadir/d1/newfile2"
+$XFS_IO_PROG -c "falloc 0 $datasize" "$datadir/d1/newfile2"
+$XFS_IO_PROG -c "fsync" "$datadir/d1/newfile2"
+
+# Add new files to midlayer with redirects to the files we appended to
the lower dir
+_overlay_scratch_mount_dirs $datadir $lowerdir $workdir -o
redirect_dir=on,index=on,metacopy=on
+mv "$newfile1" "$SCRATCH_MNT/_newfile1"
+mv "$newfile2" "$SCRATCH_MNT/_newfile2"
+umount_overlay
+mv "$lowerdir/_newfile1" "$lowerdir/d1/newfile1"
+mv "$lowerdir/_newfile2" "$lowerdir/d1/newfile2"
+
+echo -e "\n== Verify files appended to data layer while mounted are
available after remount =="
+mount_overlay
+
+ls "$SCRATCH_MNT/d1"
+check_file_size_contents "$newfile1" $datasize "new file 1"
+check_file_size_contents "$newfile2" $datasize "new file 2"
+check_file_size_contents "$SCRATCH_MNT/file1" $datasize $datacontent
+
+umount_overlay
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/087.out b/tests/overlay/087.out
new file mode 100644
index 00000000..db16c8a2
--- /dev/null
+++ b/tests/overlay/087.out
@@ -0,0 +1,13 @@
+QA output created by 087
+
+== Create overlayfs and access files in data layer ==
+
+== Add new files to data layer, online and offline ==
+/root/projects/xfstests-dev/tests/overlay/087: line 138:
/mnt/scratch/ovl-mnt/d1/newfile1: No such file or directory
+newfile1 expected missing
+/root/projects/xfstests-dev/tests/overlay/087: line 139:
/mnt/scratch/ovl-mnt/d1/newfile2: No such file or directory
+newfile2 expected missing
+
+== Verify files appended to data layer while mounted are available
after remount ==
+newfile1
+newfile2
--
2.43.0

