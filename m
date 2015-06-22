From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH] SELinux: Create a common helper to determine an inode
 label [ver #3]
Date: Mon, 22 Jun 2015 17:48:52 -0400
Message-ID: <CAHC9VhT+SCFVwfUZEC9X5m62Y5UTCyd=WYePbJCU9snaeQbdFw@mail.gmail.com>
References: <6033.1434651905@warthog.procyon.org.uk>
	<9833421.4OAA7AQtgN@sifl>
	<9305.1434966107@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <9305.1434966107@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 22, 2015 at 5:41 AM, David Howells <dhowells@redhat.com> wrote:
> Paul Moore <paul@paul-moore.com> wrote:
>
>> This patch looks fine to me and I think there is an advantage to merging this
>> regardless of what happens with the "unioning" work so I'm inclined to queue
>> this up now unless you would prefer to resubmit with the union patches?
>
> If you could queue it up now, that'd be great!

All set.  As soon as the merge window closes I'll push it to the
selinux#next branch.

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
