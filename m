Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2C6CE7A95
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Sep 2023 14:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbjIYOMV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 10:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjIYOMU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2023 10:12:20 -0400
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7A7C0
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2023 07:12:12 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout01.posteo.de (Postfix) with ESMTPS id DA3BB24002A
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2023 16:12:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1695651124; bh=6OA6viO4BmJ/ut/5SYHtXaDy8CFqJ+t9AdO62BFm/Wc=;
        h=MIME-Version:Content-Transfer-Encoding:Date:From:To:Subject:
         Message-ID:From;
        b=ajt68SkYxl223Mcnaip3uQE5ADzQ8vbEmEunkxruVGC35+4JIWiwTxVTDFSoeoYom
         PGWJZ6RZCNdAtkVT7GE0wVtv3YefxNdhZBZ2Byfpt3Xk7E3jIEeO/yfHXXAGvi4rBw
         0kPRgNhNQB12I09j0PUSQLXLI0HOi5zvPf8fz9XM2lhi0AtPL/68bavD+xfJQJUegT
         CJTX6LdDgQTY2esYiil/zobUoHT+vFbqE7C/APzoVOdXuS5qgOZEiL111hCbX2wGwC
         V20GhPiIwia7Skb7GTMsBAMkmJH1lJvZYoQCSTIKoIzZb5Jl9a3QSQAOeUGEp4IYz5
         uisJyrUkAR3Sw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4RvPvS3KJ6z9ryW
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2023 16:12:04 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 Sep 2023 14:12:04 +0000
From:   alexis.b@posteo.de
To:     linux-unionfs@vger.kernel.org
Subject: Overlayfs: Deleting files from the lower dir
Message-ID: <2157158b2d38f2af38a60cf2d72b08be@posteo.de>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi,

We are using an overlayfs to make our configuration persistent.
The lower dir is /etc and the upper dir is located on the persistent
/data partition. This is the mount command we use to create the overlay:

mount -n -t overlay \
-o workdir=$WORK_DIR \
-o lowerdir=/etc \
-o upperdir=/data \
-o index=off,xino=off,redirect_dir=off,metacopy=off \
/data /etc

Problem is that when we do remove a file from
the lower dir  ("rm /etc/file1.txt" for example) and afterwards list the 
directory content with the
ls command we do get following output:

$ls /etc
file1.txt file2.txt file3.txt

$rm /etc/file1.txt

$ls /etc
ls: ./file1.txt: No such file or directory
file2.txt file3.txt


Like expected, the file is not listed anymore but we do get an error 
message ("No such file or directory"). When we list the directory
using the tree command we do not get an error but the file (possibly the 
character device to white out the deleted file?) still gets listed in 
the
output contrary to what we would expect.

We are using linux kernel version 5.10.9.


Any hint on why this does happen or how to solve this would be very 
appreciated.

Kind regards,
Alexis
