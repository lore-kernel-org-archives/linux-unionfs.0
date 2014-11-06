From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 0/7] Security: Provide unioned file support
Date: Thu, 06 Nov 2014 10:40:08 -0800
Message-ID: <545BC088.6080306@schaufler-ca.com>
References: <545BB147.4000100@schaufler-ca.com> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <6108.1415296719@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtp103.biz.mail.bf1.yahoo.com ([98.139.221.62]:28192 "EHLO
	smtp103.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbaKFSjn (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 6 Nov 2014 13:39:43 -0500
In-Reply-To: <6108.1415296719@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>

On 11/6/2014 9:58 AM, David Howells wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
>
>> I am going to have to look at this very carefully for the
>> Smack implications. I cannot have a review done for several
>> days. I do have some immediate comments below.
> Note that Smack and Tomoyo won't compile with the patches as they are because
> some changes will need to be made.  I haven't made them yet as I want to work
> out the changes for SELinux first.

There are going to be lots of implications. Please look at the
bigger picture.


>
>>>  (1) The docker source (ie. the lower layer) will all be under a single
>>>  label.
>> What does this mean? Is the "lower layer" the "real" file, or something else?
>> What is a "docker source"? What "single label" are you talking about, and
>> where does it come from? What about LSMs that have multiple labels on a file?
> Firstly, docker: https://www.docker.com/
>
> What we're dealing with is unioning two filesystems.  The way it works is that
> you start off with a "lower" filesystem that contains the basic files you want
> to appear and you overlay on top of that another filesystem such that the
> files and directories in the lower filesystem can be accessed through the
> overlay (the overlay redirects queries to the lower fs).
>
> So, say the lower fs is mounted on /foo and you mount an overlay on /bar that
> points to /foo as its lower layer.  If you access /bar/bin/ls, the overlay
> will pass that down, giving you a file referring to /foo/bin/ls.
>
> The clever bit comes when you try altering /bar/bin/ls.  At that point
> /foo/bin/ls is "copied up" to the overlay - to /bar/bin/ls becomes a real
> file.  The writes are then made to the file in the overlay - and these files
> are persistent.
>
> In theory, any further access to /bar/bin/ls will then serve up the contents
> of /bar/bin/ls and ignore /foo/bin/ls.  In practice, as things stand, if you
> have a read-only fd already referring to /foo/bin/ls through /bar/bin/ls, this
> will be unaffected by the copy up.
>
> Docker uses containers and chroots to provide not-virtual-machines, using an
> overlay to manage the root filesystem.  Indeed, you can provide several
> overlays using the same lower fs.
>
> So to answer your questions:
>
>> What does this mean?
> It has been decided that for the purposes of docker, all files within the
> docker root fs will have the same label.  We'd have to provide policy
> namespacing otherwise (I think).

That's just insane. "It has been decided" by who? Obviously not people
who care about security policies. Maybe it's good enough for your
particular use case, but labeling of files has to be up to the security
module. That's what the modules are for.

>
>> Is the "lower layer" the "real" file, or something else?
> The lower layer is a filesystem, though it contains real files.  In the case
> of unionmount (an alternative to overlayfs), there may be multiple ordered
> lower layers.
>
>> What is a "docker source"?
> The lower layer contains the "source" files for your docker image.
>
>> What "single label" are you talking about, and where does it come from?
> The label you set on the lower layer files.
>
>> What about LSMs that have multiple labels on a file?
> Setting policy is something I'll have to leave to the docker people and the
> administrators of systems that use docker.

What does that mean? If the underlying mechanism can't do the job,
how the dickens is the administrator supposed to make it happen?

>
> But all I'm proposing is a way to give the LSM access to both the file in the
> overlay and the file in the lower fs that is leeching through into the
> overlay.

But your mechanisms are simultaneously incomplete and over specified.

>
>>>  (2) The docker root (ie. the overlay/union layer) will all be under a
>>>      single, but different label set on the overlay mount (and each docker
>>>      root may be under its own label).
>> No. Sorry, but this is the one notion that doesn't work. A layer should
>> either be label transparent or restricted by some sort of range concept.
>> Giving it a label just makes it necessary to grant everyone access to objects
>> with that label.
> The problem is that we're not using a virtual machine.  Labels on the docker
> chroot and labels on the master root filesystem are under the same policy.
>
> Further, we may have several docker instances that have separate overlays on
> the same lower layer but should perhaps have separate labels.

Your proposal is a cop out. It may work in a limited set of cases.
It is not a general solution.

>
>>>  (3) Inodes in the overlayfs upper layer will be given the overlay label.
>> Could you explain your terminology? I have no idea what the "overlay label"
>> might be. Is it the real one on the real filesystem? What about attributes
>> other than the access label? Smack has execution labels and a transmute
>> attribute as well as the access label.
> The overlay label is the label on the inode in the overlay layer (overlayfs)
> or that would be on the inode if it existed (unionmount).
>
>>>  (6) An extra label slot will be placed in struct file_security_struct to
>>>      hold the overlay label.
>> Are you assuming a single overlay layer? 
> There can only be only overlay at the top.  It may have lower layers that are
> also overlays, but we really want the top label.
>
> David
>

