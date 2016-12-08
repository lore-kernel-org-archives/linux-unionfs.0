From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay: stress test changes to top and bottom layers simultaneously
Date: Thu, 8 Dec 2016 16:27:41 +0200
Message-ID: <CAOQ4uxhpW-GSggCOxpDdjJ_gYcM0ivY7CSwmSfJXaEygzs6ccg@mail.gmail.com>
References: <20161208035844.18544-1-tytso@mit.edu> <20161208043739.GF29149@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20161208043739.GF29149@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Dec 8, 2016 at 6:37 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Dec 07, 2016 at 10:58:44PM -0500, Theodore Ts'o wrote:
...
>> diff --git a/tests/overlay/group b/tests/overlay/group
>> index 5740d2a2..b310aebe 100644
>> --- a/tests/overlay/group
>> +++ b/tests/overlay/group
>> @@ -19,3 +19,4 @@
>>  014 auto quick copyup
>>  015 auto quick whiteout
>>  016 auto quick
>> +017 auto quick
>
> It runs for 10 minutes, not a "quick" test :)
>

Yes better make it "stress".

and FYI, I was so overwhelmed with how much this test grinds my laptop's
CPU that I rushed to fix the command:

./check -overlay -x stress overlay/???

Which seems to have been broken forever.

Amir.
