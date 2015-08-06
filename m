From: Alkis Georgopoulos <alkisg@gmail.com>
Subject: How to specify the mount points for multiple lower layers?
Date: Thu, 06 Aug 2015 11:25:16 +0300
Message-ID: <55C319EC.4080707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33002 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbbHFIZS (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 6 Aug 2015 04:25:18 -0400
Received: by wijp15 with SMTP id p15so12688480wij.0
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Aug 2015 01:25:17 -0700 (PDT)
Received: from [10.161.254.11] (srv1-dide.ioa.sch.gr. [81.186.20.0])
        by smtp.googlemail.com with ESMTPSA id yu4sm8184129wjc.43.2015.08.06.01.25.17
        for <linux-unionfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 06 Aug 2015 01:25:17 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

 From https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt:
mount -t overlay overlay -olowerdir=/lower1:/lower2:/lower3 /merged

How can I specify that I want e.g. lower2 to be mounted at merged/home?

If all lower* layers can only be mounted at /merged, then I don't see 
any way at all that overlayfs would allow me to combine e.g.
Partition  MountDir  MergedDir
------------------------------
/dev/sda1  /root-fs  /merged
/dev/sda2  /home-fs  /merged/home

I even tried to create a fake directory structure like this:
/dev/sda2 /fakedir/home /merged
...so that I would mount /dev/sda2 to /fakedir/home, and then try to use 
lower2=/fakedir, but then I got a different issue, that overlayfs 
doesn't include submounts, so sda2 wasn't visible at all then.

So I was unable to combine the root and home partitions to the correct 
paths using overlayfs (I'm planning to use a tmpfs as the upper dir 
later on).

Any help? Thank you!
