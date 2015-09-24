From: Andy Whitcroft <apw@canonical.com>
Subject: Re: overlayfs + linux user namespace issue
Date: Thu, 24 Sep 2015 12:16:32 +0100
Message-ID: <20150924111632.GA19632@bark>
References: <CAM45rib8eDrSkRwXo+0ZhannWNmyUe1Tqq9T13csGVdfWXbwXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33332 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbbIXLQg (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 24 Sep 2015 07:16:36 -0400
Received: by wiclk2 with SMTP id lk2so23246640wic.0
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Sep 2015 04:16:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAM45rib8eDrSkRwXo+0ZhannWNmyUe1Tqq9T13csGVdfWXbwXw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexey Naidyonov <alexey.naidyonov@gmail.com>
Cc: linux-unionfs@vger.kernel.org

On Thu, Sep 24, 2015 at 01:43:23PM +0300, Alexey Naidyonov wrote:
> Hello;
> 
> I found that writing to overlayfs mount may be denied to a process
> with own user namespace and uid=0 inside that namespace, unless I
> explicitly chown lower-work/work directory to a parent namespace uid
> corresponding to that user namespace uid 0.
> 
> The test case might be found at
> https://unix.stackexchange.com/questions/229782/overlayfs-doesnt-work-with-unprivileged-user-namespace
> 
> Tried with debian's 4.1.6 and 4.2-trunk.
> 
> Could someone please clarify if this is a bug or a feature, and if
> this might be changed in future?

Which directory are you saying must belong to namespace root here?
You should not be able to read things in the underlay that the namespace
root could not read, and not write to overlay directories that your
namepsace root cannot write.  If you could you could copy up protected
files into an overlay by specifying a protected underlay (think ~/over
overlaying on /etc) or overwrite profiled files by specifying a protected
overlay (think ~/under overlayed by /etc).

-apw
